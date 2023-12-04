import 'package:chat_app/features/auth/view/auth/auth_form_state.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_screen_controller.g.dart';

@riverpod
class AuthScreenController extends _$AuthScreenController {
  @override
  AuthFormState build(AuthFormType formType) {
    return AuthFormState(formType: formType);
  }

  Future<AsyncValue<bool>> submit({
    required String email,
    required String password,
    String? username,
  }) async {
    state = state.copyWith(value: const AsyncLoading());

    final result = await AsyncValue.guard(
      () => _authenticate(email: email, password: password),
    );

    state = state.copyWith(value: result);

    return result;
  }

  Future<bool> _authenticate({
    required String email,
    required String password,
  }) {
    switch (state.formType) {
      case AuthFormType.login:
        return ref
            .watch(authRepositoryProvider)
            .signInWithEmailAndPassword(email: email, password: password);
      case AuthFormType.signup:
        return ref
            .watch(authRepositoryProvider)
            .signUp(email: email, password: password);
    }
  }

  void updateFormType(AuthFormType formType) {
    state = state.copyWith(formType: formType);
  }
}
