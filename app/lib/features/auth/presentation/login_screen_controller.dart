import 'package:chat_app/features/auth/repository/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_screen_controller.g.dart';

@riverpod
class LoginScreenController extends _$LoginScreenController {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<bool> authenticate(String email, String password) async {
    state = const AsyncLoading();
    await AsyncValue.guard(
      () => ref
          .watch(authRepositoryProvider)
          .signInWithEmailAndPassword(email: email, password: password),
    );
    state = const AsyncData(null);
    return state.hasError == false;
  }
}
