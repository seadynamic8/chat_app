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
        AutoRoute(page: AuthRoute.page),
        AutoRoute(
          page: MainNavigation.page,
          initial: true,
          guards: [authGuard],
          children: [
            AutoRoute(
              page: TabsNavigation.page,
              initial: true,
              children: [
                AutoRoute(
                  page: ExploreNavigation.page,
                  initial: true,
                  children: [
                    AutoRoute(page: ExploreRoute.page, initial: true),
                  ],
                ),
                AutoRoute(page: ChatLobbyRoute.page),
                AutoRoute(
                  page: ProfileNavigation.page,
                  children: [
                    AutoRoute(page: PrivateProfileRoute.page, initial: true),
                    AutoRoute(page: SettingsRoute.page),
                  ],
                ),
              ],
            ), // End TabsNavigationRoute
            AutoRoute(page: SearchRoute.page),
            AutoRoute(page: PublicProfileRoute.page),
          ],
        ),
      ];
}

@riverpod
AppRouter appRouter(AppRouterRef ref) {
  return AppRouter(authGuard: ref.watch(authGuardProvider));
}
