import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:chat_app/features/auth/domain/block_state.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/auth/domain/token.dart';
import 'package:chat_app/features/auth/domain/user_access.dart';
import 'package:chat_app/features/home/application/current_user_id_provider.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/utils/exceptions.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:chat_app/utils/username_generate_data.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
          .select('*')
          .eq('id', profileId)
          .single();

      return Profile.fromMap(profileUser);
    } catch (error, st) {
      logger.error('getProfile()', error, st);
      throw Exception('Unable to get profile'.i18n);
    }
  }

  // This will be used for now to get initial list of online profiles,
  // so that we can get a more accurate list on load.
  Future<List<Profile>> getOtherOnlineProfiles(List<String> userIds) async {
    try {
      final profiles = await supabase
          .from('profiles')
          .select('''
            id, 
            username, 
            birthdate, 
            gender,
            avatar_url, 
            country, 
            ... online_status (online_at)
          ''')
          .inFilter('id', userIds)
          .neq('id', currentUserId!)
          .order('online_at',
              referencedTable: 'online_status', ascending: false);

      return profiles.map((profile) => Profile.fromMap(profile)).toList();
    } catch (error, st) {
      logger.error('getOtherOnlineProfiles()', error, st);
      throw Exception('Unable to get other online profiles'.i18n);
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

    supabase
        .channel('public:profiles:id=eq.$profileId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'profiles',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: profileId,
          ),
          callback: (PostgresChangePayload payload) {
            final profile = payload.newRecord;

            streamController.add(Profile.fromMap(profile));
          },
        )
        .subscribe();

    yield* streamController.stream;
  }

  Future<void> updateProfile(Profile profile) async {
    try {
      await supabase
          .from('profiles')
          .update(profile.toMap())
          .eq('id', currentUserId!);
    } on PostgrestException catch (error, st) {
      if (error.message ==
          'duplicate key value violates unique constraint "profiles_username_key"') {
        throw DuplicateUsernameException();
      }
      logger.error('updateProfile()', error, st);
      throw Exception('Unable to update profile'.i18n);
    } catch (error, st) {
      logger.error('updateProfile()', error, st);
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
      logger.error('storeAvatar()', error, st);
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
      logger.error('signUp()', error, st);
      rethrow;
    } catch (error, st) {
      logger.error('signUp()', error, st);
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
      logger.error('resendOTP()', error, st);
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
      logger.error('verifyOTP()', error, st);
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
      logger.error('resetPassword()', error, st);
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
      logger.error('updateUser()', error, st);
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
    } on AuthException catch (error, st) {
      if (error.message == "name resolution failed") {
        logger.f(
            'AuthRepository signInWithEmailAndPassword(): Something went wrong with email');
        throw UnknownEmailSignin();
      }
      if (error.message == "Invalid login credentials") {
        logger.i(error.message);
        rethrow;
      }
      logger.error('signInWithEmailAndPassword()', error, st);
      rethrow;
    } catch (error, st) {
      logger.error('signInWithEmailAndPassword()', error, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await setOfflineAt();
      await supabase.auth.signOut();
    } catch (error, st) {
      logger.error('signOut()', error, st);
      rethrow;
    }
  }

  Future<String> generateJWTToken() async {
    try {
      final jwtResponse = await supabase.functions.invoke('jwt_token');

      if (jwtResponse.status > 400) {
        throw Exception(
            'JWT Token failed to be retrieved, Response Code: ${jwtResponse.status}');
      }
      return (jwtResponse.data as String).replaceAll('"', '');
    } catch (error, st) {
      logger.error('generateJWTToken()', error, st);
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
            'blocker_id', currentUserId!);

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

  // * User Access

  Stream<UserAccess> getUserAccessChanges(String profileId) {
    final userAccessStream = supabase
        .from('user_access')
        .stream(primaryKey: ['id']).eq('id', profileId);

    return userAccessStream.map((userAccesses) {
      return UserAccess.fromMap(userAccesses.first);
    });
  }

  Future<void> updateUserAccess(String profileId, UserAccess userAccess) async {
    try {
      await supabase
          .from('user_access')
          .update(userAccess.toMap())
          .eq('id', profileId);
    } catch (error, st) {
      logger.error('updateUserAccess()', error, st);
      throw Exception('Something went wrong with updating your subscription');
    }
  }

  // * Online Status

  Future<void> setOnlineAt() async {
    try {
      await supabase.from('online_status').upsert({
        'id': currentUserId,
        'online_at': DateTime.now().toUtc().toIso8601String(),
        'offline_at': null, // clear offline timestamp
      });
    } catch (error, st) {
      logger.error('setOnlineAt()', error, st);
    }
  }

  Future<void> setOfflineAt() async {
    try {
      await supabase.from('online_status').upsert({
        'id': currentUserId,
        'offline_at': DateTime.now().toUtc().toIso8601String(),
        'online_at': null // clear online timestamp
      });
    } catch (error, st) {
      logger.error('setOfflineAt()', error, st);
    }
  }

  Stream<DateTime?> watchOfflineTime(String profileId) {
    final onlineStatusStream = supabase
        .from('online_status')
        .stream(primaryKey: ['id']).eq('id', profileId);

    return onlineStatusStream.map((onlineStatuses) {
      if (onlineStatuses.isEmpty) return null;

      final offlineAtString = onlineStatuses.first['offline_at'];
      return offlineAtString != null ? DateTime.parse(offlineAtString) : null;
    });
  }

  // * Notifications

  Future<bool> hasToken(Token token) async {
    try {
      final tokens = await supabase.rpc('fcm_token_count', params: {
        'profile_id': currentUserId,
        'fcm': token.fcmValue,
        'apns': token.apnsValue
      });

      return tokens > 0;
    } catch (error, st) {
      logger.error('hasToken()', error, st);
      rethrow;
    }
  }

  Future<void> addFCMToken(Token token) async {
    try {
      final fcmSecretId = await createSecret(token.fcmValue);
      final tokenMap = {
        'fcm_id': fcmSecretId,
        'profile_id': currentUserId,
      };

      if (token.apnsValue != null) {
        final apnsSecretId = await createSecret(token.apnsValue!);
        tokenMap['apns_id'] = apnsSecretId;
      }

      await supabase.from('fcm_tokens').insert(tokenMap);
    } catch (error, st) {
      logger.error('addFCMToken()', error, st);
    }
  }

  Future<void> createNofitication(
    String otherProfileId, {
    Map<String, String>? notification,
    Map<String, String>? data,
  }) async {
    try {
      final Map<String, dynamic> body = {'otherProfileId': otherProfileId};
      if (notification != null) body['notification'] = notification;
      if (data != null) body['data'] = data;

      await supabase.functions.invoke('create_notification', body: body);
    } catch (error, st) {
      logger.error('createNotification()', error, st);
    }
  }

  // * Vault methods

  Future<String> createSecret(String secret) async {
    try {
      final secretId =
          await supabase.rpc('create_vault_secret', params: {'secret': secret});
      return secretId;
    } catch (error, st) {
      logger.error('createSecret()', error, st);
      rethrow;
    }
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
            .select()
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
      logger.error('_createProfileWithLanguageAndUniqueUsername()', error, st);
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
  return authRepository.getUserAccessChanges(currentProfileId);
}

@riverpod
Stream<DateTime?> offlineAt(OfflineAtRef ref, String profileId) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.watchOfflineTime(profileId);
}
