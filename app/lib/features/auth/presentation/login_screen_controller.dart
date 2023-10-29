import 'package:chat_app/features/auth/repository/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'login_screen_controller.g.dart';

@riverpod
class LoginScreenController extends _$LoginScreenController {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<AsyncValue<AuthResponse>> authenticate(
      String email, String password) async {
    state = const AsyncLoading();

    final result = await AsyncValue.guard(
      () => ref
          .watch(authRepositoryProvider)
          .signInWithEmailAndPassword(email: email, password: password),
    );

    state = result;

    return result;
  }
}
