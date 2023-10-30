import 'package:chat_app/features/auth/presentation/auth_form_state.dart';
import 'package:chat_app/features/auth/repository/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:username_generator/username_generator.dart';

part 'auth_screen_controller.g.dart';

@riverpod
class AuthScreenController extends _$AuthScreenController {
  @override
  AuthFormState build(AuthFormType formType) {
    return AuthFormState(formType: formType);
  }

  Future<AsyncValue<AuthResponse>> submit({
    required String email,
    required String password,
    String? username,
  }) async {
    state = state.copyWith(value: const AsyncLoading());

    final result = await AsyncValue.guard(
      () => _authenticate(email: email, password: password, username: username),
    );

    state = state.copyWith(value: result);

    return result;
  }

  Future<AuthResponse> _authenticate({
    required String email,
    required String password,
    String? username,
  }) {
    switch (state.formType) {
      case AuthFormType.login:
        return ref
            .watch(authRepositoryProvider)
            .signInWithEmailAndPassword(email: email, password: password);
      case AuthFormType.signup:
        if (username == null || username.isEmpty) {
          username = UsernameGenerator().generateRandom();
        }

        return ref
            .watch(authRepositoryProvider)
            .signUp(email: email, password: password, username: username);
    }
  }

  void updateFormType(AuthFormType formType) {
    state = state.copyWith(formType: formType);
  }
}
