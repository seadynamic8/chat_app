import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/auth/repository/auth_repository.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_guard.g.dart';

class AuthGuard extends AutoRouteGuard {
  AuthGuard({required this.loggedIn});

  final bool loggedIn;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (loggedIn) {
      // Continue navigation
      resolver.next();
    } else {
      // Navigate to auth screen to get authenticated

      // Redirect will remove the redirected route from the stack after completion
      resolver.redirect(
        AuthRoute(onAuthResult: (isSuccess) => resolver.next(isSuccess)),
      );
    }
  }
}

@riverpod
AuthGuard authGuard(AuthGuardRef ref) {
  final loggedIn = ref.watch(authRepositoryProvider).currentSession != null;
  return AuthGuard(loggedIn: loggedIn);
}
