import 'dart:io';

import 'package:chat_app/features/auth/data/current_profile_provider.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/utils/username_generate_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final profileUser = await supabase
        .from('profiles')
        .select<Map<String, dynamic>>('*')
        .eq('id', profileId)
        .single();

    return Profile.fromMap(profileUser);
  }

  Future<void> updateProfile(Profile profile) async {
    await supabase.from('profiles').update({
      'id': profile.id!,
      'username': profile.username!,
      'birthdate': profile.birthdate?.toIso8601String(),
      'avatar_url': profile.avatarUrl,
      'gender': profile.gender?.name,
      'language': profile.language.toString(),
      'country': profile.country,
    }).eq('id', currentUserId);
  }

  // The custom imagePath below is not the same as returned by API call
  // The custom imagePath is returned because it is used for getting public URL
  Future<String> storeAvatar(File image) async {
    final extension = p.extension(image.path);
    final currentProfileId = ref.read(currentProfileProvider).id!;
    final imagePath =
        '$currentProfileId/images/avatar/${DateTime.timestamp()}$extension';
    // Returns image path on server from root, and not the same as the custom imagePath
    await supabase.storage.from('media').upload(imagePath, image);
    return imagePath;
  }

  String getAvatarPublicURL(String imagePath) {
    return supabase.storage.from('media').getPublicUrl(imagePath);
  }

  // Create New User
  Future<Profile?> signUp({
    required String email,
    required String password,
    // required String username,
  }) async {
    final response =
        await supabase.auth.signUp(email: email, password: password);

    if (response.user == null) return null;

    // Empty profile since the user is not verified yet
    return const Profile();
  }

  // Resend only for signup, email change, or phone change
  // - For resetPassword, use resetPassword
  Future<void> resendOTP({
    required AuthOtpType authOtpType,
    required String email,
  }) async {
    await supabase.auth.resend(type: authOtpType.otpType, email: email);
  }

  // Use either email or phone, not both
  Future<Profile?> verifyOTP({
    String? email,
    String? phone,
    required String pinCode,
    required AuthOtpType authOtpType,
  }) async {
    final verifyResponse = await supabase.auth.verifyOTP(
      email: email,
      phone: phone,
      token: pinCode,
      type: authOtpType.otpType,
    );

    if (verifyResponse.user == null) return null;

    return _getAndSetProfile(
      verifyResponse.user!.id,
      isSignUp: authOtpType == AuthOtpType.signup,
    );
  }

  // Sends a reset password email to user
  // To be used with verifyOTP (type recovery)
  // and updateUser after they verify the code, they can update the password
  Future<void> resetPassword(String email) async {
    await supabase.auth.resetPasswordForEmail(email);
  }

  Future<void> updateUser({
    String? email,
    String? password,
    String? pinCode,
  }) async {
    await supabase.auth.updateUser(UserAttributes(
      email: email,
      password: password,
      nonce: pinCode,
    ));
  }

  // Login
  Future<Profile?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final response = await supabase.auth
        .signInWithPassword(email: email, password: password);

    if (response.user == null) return null;

    return _getAndSetProfile(response.user!.id);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<String> generateJWTToken() async {
    final jwtResponse = await supabase.functions
        .invoke('jwt_token', responseType: ResponseType.text);

    if (jwtResponse.status != null && jwtResponse.status! > 400) {
      throw Exception(
          'JWT Token failed to be retrieved, Response Code: ${jwtResponse.status}');
    }
    return (jwtResponse.data as String).replaceAll('"', '');
  }

  Future<Profile?> _getAndSetProfile(
    String profileId, {
    bool isSignUp = false,
  }) async {
    late Profile? profile;
    if (isSignUp) {
      // This ensures username exists
      profile = await _generateProfileWithUniqueUsername(profileId);
    } else {
      profile = await getProfile(profileId);
    }
    if (profile == null) return null;

    ref.read(currentProfileProvider.notifier).set(profile);

    return profile;
  }

  Future<Profile?> _generateProfileWithUniqueUsername(
      String currentUserId) async {
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
          })
          .select<Map<String, dynamic>>()
          .single();

      if (userResponse.isEmpty) {
        currentTry += 1;
      } else {
        success = true;
      }
    }
    if (userResponse == null) return null;

    return Profile.fromMap(userResponse);
  }
}

@Riverpod(keepAlive: true)
SupabaseClient supabase(SupabaseRef ref) {
  return Supabase.instance.client;
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  return AuthRepository(ref: ref, supabase: supabase);
}

@Riverpod(keepAlive: true)
Session? currentSession(CurrentSessionRef ref) {
  return ref.watch(authRepositoryProvider).currentSession;
}

@Riverpod(keepAlive: true)
Stream<AuthState> authStateChanges(AuthStateChangesRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.onAuthStateChanges();
}
