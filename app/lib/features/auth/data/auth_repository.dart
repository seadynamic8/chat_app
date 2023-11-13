import 'dart:io';

import 'package:chat_app/features/auth/data/current_profile_provider.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:username_generator/username_generator.dart';

part 'auth_repository.g.dart';

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
      'birthdate': profile.birthdate!.toIso8601String(),
      'avatar_url': profile.avatarUrl,
      'gender': profile.gender!.name,
    }).eq('id', currentUserId);
  }

  // Returns image path on server (NOT Public URL)
  Future<String> storeAvatar(String imagePath, File image) async {
    return await supabase.storage.from('avatars').upload(imagePath, image);
  }

  String getAvatarPublicURL(String imagePath) {
    return supabase.storage.from('avatars').getPublicUrl(imagePath);
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

  // Use either email or phone, not both
  Future<Profile?> verifyOTP({
    String? email,
    String? phone,
    required String pinCode,
  }) async {
    final verifyResponse = await supabase.auth.verifyOTP(
      email: email,
      phone: phone,
      token: pinCode,
      type: OtpType.signup,
    );

    if (verifyResponse.user == null) return null;

    // This is ensure username exists
    final profile =
        await _generateProfileWithUniqueUsername(verifyResponse.user!.id);

    if (profile == null) return null;

    ref.read(currentProfileProvider.notifier).set(profile);

    return profile;
  }

  // Login
  Future<Profile?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final response = await supabase.auth
        .signInWithPassword(email: email, password: password);

    if (response.user == null) return null;

    final profile = await getProfile(response.user!.id);
    ref.read(currentProfileProvider.notifier).set(profile);

    return profile;
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

  Future<Profile?> _generateProfileWithUniqueUsername(
      String currentUserId) async {
    var success = false;
    const retryTimes = 3;
    var currentTry = 1;

    Map<String, dynamic>? userResponse;

    // Loop until we get a successful generated profile with unique username
    while (success == false && currentTry <= retryTimes) {
      final username = UsernameGenerator().generateRandom();

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
