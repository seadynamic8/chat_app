import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:chat_app/features/auth/domain/block_state.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/auth/domain/user_access.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/utils/exceptions.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:chat_app/utils/username_generate_data.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:username_gen/username_gen.dart';
import 'package:path/path.dart' as p;

part 'auth_repository.g.dart';

enum AuthOtpType {
  signup(otpType: OtpType.signup),
  recovery(otpType: OtpType.recovery);

  const AuthOtpType({required this.otpType});

  final OtpType otpType;
}

class AuthRepository {
  AuthRepository({required this.ref, required this.supabase});

  final Ref ref;
  final SupabaseClient supabase;

  Session? get currentSession => supabase.auth.currentSession;

  Stream<AuthState> onAuthStateChanges() => supabase.auth.onAuthStateChange;

  String? get currentUserId => supabase.auth.currentUser?.id;

  Future<Profile> getProfile(String profileId) async {
    try {
      final profileUser = await supabase
          .from('profiles')
          .select<Map<String, dynamic>>('*')
          .eq('id', profileId)
          .single();

      return Profile.fromMap(profileUser);
    } catch (error, st) {
      await logError('getProfile()', error, st);
      throw Exception('Unable to get profile'.i18n);
    }
  }

  Future<List<Profile>> getOtherProfiles(List<String> otherUserIds) async {
    try {
      final profiles = await supabase
          .from('profiles')
          .select<List<Map<String, dynamic>>>('*')
          .in_('id', otherUserIds)
          .order('online_at', ascending: false);

      return profiles.map((profile) => Profile.fromMap(profile)).toList();
    } catch (error, st) {
      await logError('getProfiles()', error, st);
      throw Exception('Unable to get profiles'.i18n);
    }
  }

  Stream<Profile> watchProfile(String profileId) {
    final profilesStream = supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', profileId)
        .limit(1);

    return profilesStream.map((profiles) => Profile.fromMap(profiles.first));
  }

  Stream<Profile> watchProfileChanges(String profileId) async* {
    final streamController = StreamController<Profile>();

    supabase.channel('public:profiles:id=eq.$profileId').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
          event: 'UPDATE',
          schema: 'public',
          table: 'profiles',
          filter: 'id=eq.$profileId'),
      (payload, [ref]) {
        final profile = payload['new'];

        streamController.add(Profile.fromMap(profile));
      },
    ).subscribe();

    yield* streamController.stream;
  }

  Future<void> updateProfile(Profile profile) async {
    try {
      await supabase
          .from('profiles')
          .update(profile.toMap())
          .eq('id', currentUserId);
    } on PostgrestException catch (error, st) {
      if (error.message ==
          'duplicate key value violates unique constraint "profiles_username_key"') {
        throw DuplicateUsernameException();
      }
      await logError('updateProfile()', error, st);
      throw Exception('Unable to update profile'.i18n);
    } catch (error, st) {
      await logError('updateProfile()', error, st);
      throw Exception('Something went wrong with creating user'.i18n);
    }
  }

  // The custom imagePath below is not the same as returned by API call
  // The custom imagePath is returned because it is used for getting public URL
  Future<String> storeAvatar(File image) async {
    final extension = p.extension(image.path);
    final imagePath =
        '$currentUserId/images/avatar/${DateTime.timestamp()}$extension';
    try {
      // Returns image path on server from root, and not the same as the custom imagePath
      await supabase.storage.from('media').upload(imagePath, image);
      return imagePath;
    } catch (error, st) {
      await logError('storeAvatar()', error, st);
      throw Exception('Unable to save avatar'.i18n);
    }
  }

  String getAvatarPublicURL(String imagePath) {
    return supabase.storage.from('media').getPublicUrl(imagePath);
  }

  // Create New User
  Future<bool> signUp({
    required String email,
    required String password,
    // required String username,
  }) async {
    try {
      final response =
          await supabase.auth.signUp(email: email, password: password);

      return response.user != null;
    } on AuthException catch (error, st) {
      if (error.message == "User already registered") {
        logger.w('AuthRepository signUp(): Email already registered');
        throw DuplicateEmailException();
      }
      logError('signUp()', error, st);
      rethrow;
    } catch (error, st) {
      await logError('signUp()', error, st);
      rethrow;
    }
  }

  // Resend only for signup, email change, or phone change
  // - For resetPassword, use resetPassword
  Future<void> resendOTP({
    required AuthOtpType authOtpType,
    required String email,
  }) async {
    try {
      await supabase.auth.resend(type: authOtpType.otpType, email: email);
    } catch (error, st) {
      await logError('resendOTP()', error, st);
      rethrow;
    }
  }

  // Use either email or phone, not both
  Future<bool> verifyOTP({
    String? email,
    String? phone,
    required String pinCode,
    required AuthOtpType authOtpType,
  }) async {
    try {
      final verifyResponse = await supabase.auth.verifyOTP(
        email: email,
        phone: phone,
        token: pinCode,
        type: authOtpType.otpType,
      );

      if (verifyResponse.user == null) return false;

      if (authOtpType == AuthOtpType.signup) {
        return await _createProfileWithLanguageAndUniqueUsername(
            verifyResponse.user!.id);
      }
      return true;
    } catch (error, st) {
      await logError('verifyOTP()', error, st);
      rethrow;
    }
  }

  // Sends a reset password email to user
  // To be used with verifyOTP (type recovery)
  // and updateUser after they verify the code, they can update the password
  Future<void> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
    } catch (error, st) {
      await logError('resetPassword()', error, st);
      rethrow;
    }
  }

  Future<void> updateUser({
    String? email,
    String? password,
    String? pinCode,
  }) async {
    try {
      await supabase.auth.updateUser(UserAttributes(
        email: email,
        password: password,
        nonce: pinCode,
      ));
    } catch (error, st) {
      await logError('updateUser()', error, st);
      rethrow;
    }
  }

  // Login
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth
          .signInWithPassword(email: email, password: password);

      return response.user != null;
    } catch (error, st) {
      await logError('signInWithEmailAndPassword()', error, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await setOfflineAt();
      await supabase.auth.signOut();
    } catch (error, st) {
      await logError('signOut()', error, st);
      rethrow;
    }
  }

  Future<String> generateJWTToken() async {
    try {
      final jwtResponse = await supabase.functions
          .invoke('jwt_token', responseType: ResponseType.text);

      if (jwtResponse.status != null && jwtResponse.status! > 400) {
        throw Exception(
            'JWT Token failed to be retrieved, Response Code: ${jwtResponse.status}');
      }
      return (jwtResponse.data as String).replaceAll('"', '');
    } catch (error, st) {
      await logError('generateJWTToken()', error, st);
      rethrow;
    }
  }

  // * Blocked Users

  // Need two streams, because API only allows one filter
  // And not filtering at all would potentially pull too many records later.

  Stream<bool> watchCurrentBlocking(String otherProfileId) {
    final currentBlockStream = supabase
        .from('blocked_users')
        .stream(primaryKey: ['blocker_id', 'blocked_id']).eq(
            'blocker_id', currentUserId);

    return currentBlockStream.map((blockedUsers) {
      final blocked = blockedUsers.firstWhereOrNull((user) =>
          user['blocker_id'] == currentUserId &&
          user['blocked_id'] == otherProfileId);
      return blocked?.isNotEmpty ?? false;
    });
  }

  Stream<bool> watchOtherBlocking(String otherProfileId) {
    final otherBlockStream = supabase
        .from('blocked_users')
        .stream(primaryKey: ['blocker_id', 'blocked_id']).eq(
            'blocker_id', otherProfileId);

    return otherBlockStream.map((blockedUsers) {
      final blocked = blockedUsers.firstWhereOrNull((user) =>
          user['blocker_id'] == otherProfileId &&
          user['blocked_id'] == currentUserId);
      return blocked?.isNotEmpty ?? false;
    });
  }

  // * Access Levels

  Stream<UserAccess> getAccessLevelChanges(String profileId) {
    final userAccessStream = supabase
        .from('access_levels')
        .stream(primaryKey: ['id']).eq('id', profileId);

    return userAccessStream.map((userAccesses) {
      return UserAccess.fromMap(userAccesses.first);
    });
  }

  Future<void> updateAccessLevel(
      String profileId, UserAccess userAccess) async {
    try {
      await supabase
          .from('access_levels')
          .update(userAccess.toMap())
          .eq('id', profileId);
    } catch (error, st) {
      await logError('updateAccessLevel()', error, st);
      throw Exception('Something went wrong with updating your subscription');
    }
  }

  // * Online Status

  Future<void> setOnlineAt() async {
    await supabase.from('profiles').upsert({
      'online_at': DateTime.now().toIso8601String(),
    }).eq('id', currentUserId);
  }

  Future<void> setOfflineAt() async {
    await supabase.from('profiles').upsert({
      'offline_at': DateTime.now().toIso8601String(),
    }).eq('id', currentUserId);
  }

  // * Private methods

  Future<bool> _createProfileWithLanguageAndUniqueUsername(
      String currentUserId) async {
    try {
      var success = false;
      const retryTimes = 3;
      var currentTry = 1;

      Map<String, dynamic>? userResponse;

      // Loop until we get a successful generated profile with unique username
      while (success == false && currentTry <= retryTimes) {
        final usernameGen = UsernameGen()
          ..setNames(usernameNouns)
          ..setSeperator('_')
          ..setAdjectives(usernameAdjectives);
        final username = usernameGen.generate();

        userResponse = await supabase
            .from('profiles')
            .insert({
              'id': currentUserId,
              'username': username,
              'language': Locale(I18n.locale.languageCode).toString(),
            })
            .select<Map<String, dynamic>>()
            .single();

        if (userResponse.isEmpty) {
          currentTry += 1;
        } else {
          success = true;
        }
      }
      if (userResponse == null) {
        throw Exception('Failed to generate profile with unique username');
      }
      return true;
    } catch (error, st) {
      await logError(
          '_createProfileWithLanguageAndUniqueUsername()', error, st);
      rethrow;
    }
  }
}

@riverpod
SupabaseClient supabase(SupabaseRef ref) {
  return Supabase.instance.client;
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  return AuthRepository(ref: ref, supabase: supabase);
}

@riverpod
Session? currentSession(CurrentSessionRef ref) {
  return ref.watch(authRepositoryProvider).currentSession;
}

@riverpod
Stream<AuthState> authStateChanges(AuthStateChangesRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.onAuthStateChanges();
}

@riverpod
String? currentUserId(CurrentUserIdRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.currentUserId;
}

@riverpod
Stream<Profile?> currentProfileStream(CurrentProfileStreamRef ref) {
  final currentUserId = ref.watch(currentUserIdProvider);
  if (currentUserId == null) return Stream.value(null);

  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.watchProfile(currentUserId);
}

@riverpod
Stream<Profile> profileStream(ProfileStreamRef ref, String profileId) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.watchProfile(profileId);
}

@riverpod
Stream<Profile> profileChanges(ProfileChangesRef ref, String profileId) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.watchProfileChanges(profileId);
}

@riverpod
Stream<bool> currentBlockingChanges(
    CurrentBlockingChangesRef ref, String otherProfileId) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.watchCurrentBlocking(otherProfileId);
}

@riverpod
Stream<bool> otherBlockingChanges(
    OtherBlockingChangesRef ref, String otherProfileId) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.watchOtherBlocking(otherProfileId);
}

@riverpod
Future<BlockState> blockedByChanges(
    BlockedByChangesRef ref, String otherProfileId) async {
  final currentBlocked =
      await ref.watch(currentBlockingChangesProvider(otherProfileId).future);
  final otherBlocked =
      await ref.watch(otherBlockingChangesProvider(otherProfileId).future);
  return BlockState.fromStatuses(currentBlocked, otherBlocked);
}

@riverpod
Stream<UserAccess> userAccessStream(UserAccessStreamRef ref) {
  final currentProfileId = ref.watch(currentUserIdProvider)!;
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.getAccessLevelChanges(currentProfileId);
}
