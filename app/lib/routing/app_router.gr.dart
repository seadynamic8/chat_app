// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:chat_app/features/auth/view/auth/auth_form_state.dart' as _i13;
import 'package:chat_app/features/auth/view/auth/auth_screen.dart' as _i1;
import 'package:chat_app/features/auth/view/profile/private_profile_screen.dart'
    as _i6;
import 'package:chat_app/features/auth/view/profile/profile_navigation.dart'
    as _i7;
import 'package:chat_app/features/auth/view/profile/public_profile_screen.dart'
    as _i8;
import 'package:chat_app/features/auth/view/profile/settings_screen.dart'
    as _i10;
import 'package:chat_app/features/chat/view/chat_lobby_screen.dart' as _i2;
import 'package:chat_app/features/explore/view/explore_navigation.dart' as _i3;
import 'package:chat_app/features/explore/view/explore_screen.dart' as _i4;
import 'package:chat_app/features/home/view/home_navigation.dart' as _i5;
import 'package:chat_app/features/search/view/search_screen.dart' as _i9;
import 'package:flutter/material.dart' as _i12;

abstract class $AppRouter extends _i11.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i11.PageFactory> pagesMap = {
    AuthRoute.name: (routeData) {
      final args = routeData.argsAs<AuthRouteArgs>();
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AuthScreen(
          key: args.key,
          formType: args.formType,
          onAuthResult: args.onAuthResult,
        ),
      );
    },
    ChatLobbyRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ChatLobbyScreen(),
      );
    },
    ExploreNavigation.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.ExploreNavigation(),
      );
    },
    ExploreRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.ExploreScreen(),
      );
    },
    HomeNavigation.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.HomeNavigation(),
      );
    },
    PrivateProfileRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.PrivateProfileScreen(),
      );
    },
    ProfileNavigation.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.ProfileNavigation(),
      );
    },
    PublicProfileRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<PublicProfileRouteArgs>(
          orElse: () =>
              PublicProfileRouteArgs(profileId: pathParams.getString('id')));
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.PublicProfileScreen(
          key: args.key,
          profileId: args.profileId,
        ),
      );
    },
    SearchRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.SearchScreen(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.SettingsScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.AuthScreen]
class AuthRoute extends _i11.PageRouteInfo<AuthRouteArgs> {
  AuthRoute({
    _i12.Key? key,
    required _i13.AuthFormType formType,
    required void Function(bool) onAuthResult,
    List<_i11.PageRouteInfo>? children,
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

  static const _i11.PageInfo<AuthRouteArgs> page =
      _i11.PageInfo<AuthRouteArgs>(name);
}

class AuthRouteArgs {
  const AuthRouteArgs({
    this.key,
    required this.formType,
    required this.onAuthResult,
  });

  final _i12.Key? key;

  final _i13.AuthFormType formType;

  final void Function(bool) onAuthResult;

  @override
  String toString() {
    return 'AuthRouteArgs{key: $key, formType: $formType, onAuthResult: $onAuthResult}';
  }
}

/// generated route for
/// [_i2.ChatLobbyScreen]
class ChatLobbyRoute extends _i11.PageRouteInfo<void> {
  const ChatLobbyRoute({List<_i11.PageRouteInfo>? children})
      : super(
          ChatLobbyRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatLobbyRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i3.ExploreNavigation]
class ExploreNavigation extends _i11.PageRouteInfo<void> {
  const ExploreNavigation({List<_i11.PageRouteInfo>? children})
      : super(
          ExploreNavigation.name,
          initialChildren: children,
        );

  static const String name = 'ExploreNavigation';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i4.ExploreScreen]
class ExploreRoute extends _i11.PageRouteInfo<void> {
  const ExploreRoute({List<_i11.PageRouteInfo>? children})
      : super(
          ExploreRoute.name,
          initialChildren: children,
        );

  static const String name = 'ExploreRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i5.HomeNavigation]
class HomeNavigation extends _i11.PageRouteInfo<void> {
  const HomeNavigation({List<_i11.PageRouteInfo>? children})
      : super(
          HomeNavigation.name,
          initialChildren: children,
        );

  static const String name = 'HomeNavigation';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i6.PrivateProfileScreen]
class PrivateProfileRoute extends _i11.PageRouteInfo<void> {
  const PrivateProfileRoute({List<_i11.PageRouteInfo>? children})
      : super(
          PrivateProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'PrivateProfileRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i7.ProfileNavigation]
class ProfileNavigation extends _i11.PageRouteInfo<void> {
  const ProfileNavigation({List<_i11.PageRouteInfo>? children})
      : super(
          ProfileNavigation.name,
          initialChildren: children,
        );

  static const String name = 'ProfileNavigation';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i8.PublicProfileScreen]
class PublicProfileRoute extends _i11.PageRouteInfo<PublicProfileRouteArgs> {
  PublicProfileRoute({
    _i12.Key? key,
    required String profileId,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          PublicProfileRoute.name,
          args: PublicProfileRouteArgs(
            key: key,
            profileId: profileId,
          ),
          rawPathParams: {'id': profileId},
          initialChildren: children,
        );

  static const String name = 'PublicProfileRoute';

  static const _i11.PageInfo<PublicProfileRouteArgs> page =
      _i11.PageInfo<PublicProfileRouteArgs>(name);
}

class PublicProfileRouteArgs {
  const PublicProfileRouteArgs({
    this.key,
    required this.profileId,
  });

  final _i12.Key? key;

  final String profileId;

  @override
  String toString() {
    return 'PublicProfileRouteArgs{key: $key, profileId: $profileId}';
  }
}

/// generated route for
/// [_i9.SearchScreen]
class SearchRoute extends _i11.PageRouteInfo<void> {
  const SearchRoute({List<_i11.PageRouteInfo>? children})
      : super(
          SearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i10.SettingsScreen]
class SettingsRoute extends _i11.PageRouteInfo<void> {
  const SettingsRoute({List<_i11.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}
