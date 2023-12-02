import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/home/application/channel_setup_service.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routing_observer.g.dart';

class RoutingObserver extends AutoRouteObserver {
  RoutingObserver({required this.ref});

  final Ref ref;

  @override
  void didPush(Route route, Route? previousRoute) {
    logger.t(
        'New route pushed: ${route.settings.name}, previous: ${previousRoute?.settings.name ?? ''}');
    if (route.settings.name == TabsNavigation.name) {
      ref.watch(channelSetupServiceProvider);
    }
  }

  // @override
  // void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
  //   if (previousRoute?.name == ChatNavigation.name) {
  //   }
  // }

  // @override
  // void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
  //   if (previousRoute.name == ChatNavigation.name) {
  //   }
  // }
}

@riverpod
RoutingObserver routingObserver(RoutingObserverRef ref) {
  return RoutingObserver(ref: ref);
}
