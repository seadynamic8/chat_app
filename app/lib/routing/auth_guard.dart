import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/auth/view/auth/auth_form_state.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_guard.g.dart';

class AuthGuard extends AutoRouteGuard {
  AuthGuard({required this.ref});

  final Ref ref;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    var loggedIn = ref.watch(authRepositoryProvider).currentSession != null;

    if (loggedIn) {
      // Continue navigation
      resolver.next();
    } else {
      // Navigate to auth screen to get authenticated

      // - Redirect will remove the redirected route from the stack after completion.
      resolver.redirect(
        AuthRoute(formType: AuthFormType.signup, resolver: resolver),
      );
    }
  }
}

@riverpod
AuthGuard authGuard(AuthGuardRef ref) {
  return AuthGuard(ref: ref);
}
