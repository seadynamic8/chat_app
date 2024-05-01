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
        AutoRoute(page: ErrorTalkerRoute.page),
        AutoRoute(
          page: AuthNavigation.page,
          children: [
            AutoRoute(page: AuthRoute.page, initial: true),
            AutoRoute(page: ForgotPasswordRoute.page),
            AutoRoute(page: ResetPasswordRoute.page, guards: [authGuard]),
            AutoRoute(page: AuthVerifyRoute.page),
            AutoRoute(page: SignedupRouteOne.page, guards: [authGuard]),
            AutoRoute(page: SignedupRouteTwo.page, guards: [authGuard]),
          ],
        ),
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
                    AutoRoute(page: SearchRoute.page),
                  ],
                ),
                AutoRoute(
                  page: ChatNavigation.page,
                  children: [
                    AutoRoute(page: ChatLobbyRoute.page, initial: true),
                  ],
                ),
                AutoRoute(
                  page: ProfileNavigation.page,
                  children: [
                    AutoRoute(page: PrivateProfileRoute.page, initial: true),
                    AutoRoute(page: ProfileEditRoute.page),
                    AutoRoute(page: SettingsRoute.page),
                  ],
                ),
              ],
            ), // End TabsNavigationRoute
            AutoRoute(page: PublicProfileRoute.page),
            AutoRoute(page: ChatRoomRoute.page),
            AutoRoute(page: WaitingRoute.page),
            AutoRoute(page: VideoRoomRoute.page),
            AutoRoute(page: PaywallRoute.page),
          ],
        ),
      ];
}

@riverpod
AppRouter appRouter(AppRouterRef ref) {
  return AppRouter(authGuard: ref.watch(authGuardProvider));
}
