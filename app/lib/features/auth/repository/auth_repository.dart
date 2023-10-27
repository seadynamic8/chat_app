import 'package:chat_app/features/profile/domain/profile.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository({required this.supabase});

  final SupabaseClient supabase;

  Session? get currentSession => supabase.auth.currentSession;

  Stream<AuthState> onAuthStateChanges() => supabase.auth.onAuthStateChange;

  Future<Profile?> get currentProfile async {
    final authUser = supabase.auth.currentUser!;
    final profileUser = await supabase
        .from('profiles')
        .select<Map<String, dynamic>>()
        .eq('id', authUser.id)
        .single();

    if (profileUser is String) {
      logger.e('Error: $profileUser');
      return null;
    }

    return Profile(
      id: profileUser['id'],
      email: authUser.email!,
      username:
          profileUser.containsKey('username') ? profileUser['username'] : null,
      avatarUrl: profileUser.containsKey('avatar_url')
          ? profileUser['avatar_url']
          : null,
      bio: profileUser.containsKey('bio') ? profileUser['bio'] : null,
      birthdate: profileUser['birthdate'],
    );
  }

  // Create New User
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? username,
  }) async {
    final data = username == null ? null : {'username': username};

    return await supabase.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  Future<AuthResponse> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await supabase.auth
        .signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}

@Riverpod(keepAlive: true)
SupabaseClient supabase(SupabaseRef ref) {
  return Supabase.instance.client;
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  return AuthRepository(supabase: supabase);
}

@Riverpod(keepAlive: true)
Session? currentSession(CurrentSessionRef ref) {
  return ref.watch(authRepositoryProvider).currentSession;
}

@riverpod
FutureOr<Profile?> currentProfile(CurrentProfileRef ref) async {
  return ref.watch(authRepositoryProvider).currentProfile;
}