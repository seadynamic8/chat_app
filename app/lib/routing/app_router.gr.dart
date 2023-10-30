// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:chat_app/features/auth/view/auth/auth_form_state.dart' as _i12;
import 'package:chat_app/features/auth/view/auth/auth_screen.dart' as _i1;
import 'package:chat_app/features/auth/view/profile/profile_navigation.dart'
    as _i6;
import 'package:chat_app/features/auth/view/profile/profile_screen.dart' as _i7;
import 'package:chat_app/features/auth/view/profile/settings_screen.dart'
    as _i9;
import 'package:chat_app/features/chat/view/chats_screen.dart' as _i2;
import 'package:chat_app/features/explore/view/explore_navigation.dart' as _i3;
import 'package:chat_app/features/explore/view/explore_screen.dart' as _i4;
import 'package:chat_app/features/home/view/home_navigation.dart' as _i5;
import 'package:chat_app/features/search/view/search_screen.dart' as _i8;
import 'package:flutter/material.dart' as _i11;

abstract class $AppRouter extends _i10.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i10.PageFactory> pagesMap = {
    AuthRoute.name: (routeData) {
      final args = routeData.argsAs<AuthRouteArgs>();
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AuthScreen(
          key: args.key,
          formType: args.formType,
          onAuthResult: args.onAuthResult,
        ),
      );
    },
    ChatsRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ChatsScreen(),
      );
    },
    ExploreNavigation.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.ExploreNavigation(),
      );
    },
    ExploreRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.ExploreScreen(),
      );
    },
    HomeNavigation.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.HomeNavigation(),
      );
    },
    ProfileNavigation.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.ProfileNavigation(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.ProfileScreen(),
      );
    },
    SearchRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.SearchScreen(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.SettingsScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.AuthScreen]
class AuthRoute extends _i10.PageRouteInfo<AuthRouteArgs> {
  AuthRoute({
    _i11.Key? key,
    required _i12.AuthFormType formType,
    required void Function(bool) onAuthResult,
    List<_i10.PageRouteInfo>? children,
  }) : super(
          AuthRoute.name,
          args: AuthRouteArgs(
            key: key,
            formType: formType,
            onAuthResult: onAuthResult,
          ),
          initialChildren: children,
        );

  static const String name = 'AuthRoute';

  static const _i10.PageInfo<AuthRouteArgs> page =
      _i10.PageInfo<AuthRouteArgs>(name);
}

class AuthRouteArgs {
  const AuthRouteArgs({
    this.key,
    required this.formType,
    required this.onAuthResult,
  });

  final _i11.Key? key;

  final _i12.AuthFormType formType;

  final void Function(bool) onAuthResult;

  @override
  String toString() {
    return 'AuthRouteArgs{key: $key, formType: $formType, onAuthResult: $onAuthResult}';
  }
}

/// generated route for
/// [_i2.ChatsScreen]
class ChatsRoute extends _i10.PageRouteInfo<void> {
  const ChatsRoute({List<_i10.PageRouteInfo>? children})
      : super(
          ChatsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatsRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i3.ExploreNavigation]
class ExploreNavigation extends _i10.PageRouteInfo<void> {
  const ExploreNavigation({List<_i10.PageRouteInfo>? children})
      : super(
          ExploreNavigation.name,
          initialChildren: children,
        );

  static const String name = 'ExploreNavigation';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i4.ExploreScreen]
class ExploreRoute extends _i10.PageRouteInfo<void> {
  const ExploreRoute({List<_i10.PageRouteInfo>? children})
      : super(
          ExploreRoute.name,
          initialChildren: children,
        );

  static const String name = 'ExploreRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i5.HomeNavigation]
class HomeNavigation extends _i10.PageRouteInfo<void> {
  const HomeNavigation({List<_i10.PageRouteInfo>? children})
      : super(
          HomeNavigation.name,
          initialChildren: children,
        );

  static const String name = 'HomeNavigation';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i6.ProfileNavigation]
class ProfileNavigation extends _i10.PageRouteInfo<void> {
  const ProfileNavigation({List<_i10.PageRouteInfo>? children})
      : super(
          ProfileNavigation.name,
          initialChildren: children,
        );

  static const String name = 'ProfileNavigation';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i7.ProfileScreen]
class ProfileRoute extends _i10.PageRouteInfo<void> {
  const ProfileRoute({List<_i10.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i8.SearchScreen]
class SearchRoute extends _i10.PageRouteInfo<void> {
  const SearchRoute({List<_i10.PageRouteInfo>? children})
      : super(
          SearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i9.SettingsScreen]
class SettingsRoute extends _i10.PageRouteInfo<void> {
  const SettingsRoute({List<_i10.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}
