import 'package:chat_app/features/auth/presentation/auth_form_state.dart';
import 'package:chat_app/features/auth/repository/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_screen_controller.g.dart';

@riverpod
class AuthScreenController extends _$AuthScreenController {
  @override
  AuthFormState build(AuthFormType formType) {
    return AuthFormState(formType: formType);
  }

  Future<AsyncValue<AuthResponse>> authenticate(
      String email, String password) async {
    state = state.copyWith(value: const AsyncLoading());

    final result = await AsyncValue.guard(
      () => ref
          .watch(authRepositoryProvider)
          .signInWithEmailAndPassword(email: email, password: password),
    );

    state = state.copyWith(value: result);

    return result;
  }
}
