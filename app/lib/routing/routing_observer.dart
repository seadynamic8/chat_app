import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routing_observer.g.dart';

class RoutingObserver extends AutoRouteObserver {
  RoutingObserver({required this.ref});

  final Ref ref;

  @override
  void didPush(Route route, Route? previousRoute) {}

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    if (previousRoute?.name == ChatNavigation.name) {
      ref.invalidate(getAllRoomsProvider);
    }
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    if (previousRoute.name == ChatNavigation.name) {
      ref.invalidate(getAllRoomsProvider);
    }
  }
}

@riverpod
RoutingObserver routingObserver(RoutingObserverRef ref) {
  return RoutingObserver(ref: ref);
}
