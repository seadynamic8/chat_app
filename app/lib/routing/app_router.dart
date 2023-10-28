import 'package:auto_route/auto_route.dart';
import 'package:chat_app/routing/auth_guard.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_router.gr.dart';
part 'app_router.g.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  AppRouter({super.navigatorKey, required this.authGuard});

  final AuthGuard authGuard;

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page),
        AutoRoute(
          page: HomeNavigation.page,
          initial: true,
          guards: [authGuard],
          children: [
            AutoRoute(page: ContactsRoute.page, initial: true),
            AutoRoute(page: ChatsRoute.page),
            AutoRoute(page: ProfileRoute.page),
          ],
        ),
      ];
}

@riverpod
AppRouter appRouter(AppRouterRef ref) {
  return AppRouter(authGuard: ref.watch(authGuardProvider));
}
