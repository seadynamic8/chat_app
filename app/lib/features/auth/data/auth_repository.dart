import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository({required this.supabase});

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

  // Create New User
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    final userCreateResponse =
        await supabase.auth.signUp(email: email, password: password, data: {
      'username': username,
    });

    // We could just use a DB trigger to copy username from the user table, but
    // later there may be other fields, and it makes sense to need to insert
    // into profiles table too.
    if (userCreateResponse.session != null) {
      await supabase.from('profiles').insert({
        'username': username,
      });
    }

    return userCreateResponse;
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

  Future<String> generateJWTToken() async {
    final jwtResponse = await supabase.functions
        .invoke('jwt_token', responseType: ResponseType.text);

    if (jwtResponse.status != null && jwtResponse.status! > 400) {
      throw Exception(
          'JWT Token failed to be retrieved, Response Code: ${jwtResponse.status}');
    }
    return (jwtResponse.data as String).replaceAll('"', '');
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

@Riverpod(keepAlive: true)
Stream<AuthState> authStateChanges(AuthStateChangesRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.onAuthStateChanges();
}
