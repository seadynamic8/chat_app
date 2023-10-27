import 'package:auto_route/auto_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_router.gr.dart';
part 'app_router.g.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        // AutoRoute(page: MyHomeRoute.page, initial: true),
      ];
}

@riverpod
AppRouter appRouter(AppRouterRef ref) {
  return AppRouter();
}
