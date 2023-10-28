// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:chat_app/features/auth/presentation/login_screen.dart' as _i4;
import 'package:chat_app/features/chat/presentation/chats_screen.dart' as _i1;
import 'package:chat_app/features/contacts/presentation/contacts_screen.dart'
    as _i2;
import 'package:chat_app/features/home/presentation/home_navigation.dart'
    as _i3;
import 'package:chat_app/features/profile/presentation/profile_screen.dart'
    as _i6;
import 'package:chat_app/main.dart' as _i5;
import 'package:flutter/material.dart' as _i8;

abstract class $AppRouter extends _i7.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    ChatsRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.ChatsScreen(),
      );
    },
    ContactsRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ContactsScreen(),
      );
    },
    HomeNavigation.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.HomeNavigation(),
      );
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>();
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.LoginScreen(
          key: args.key,
          onAuthResult: args.onAuthResult,
        ),
      );
    },
    MyHomeRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.MyHomePage(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.ProfileScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.ChatsScreen]
class ChatsRoute extends _i7.PageRouteInfo<void> {
  const ChatsRoute({List<_i7.PageRouteInfo>? children})
      : super(
          ChatsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatsRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ContactsScreen]
class ContactsRoute extends _i7.PageRouteInfo<void> {
  const ContactsRoute({List<_i7.PageRouteInfo>? children})
      : super(
          ContactsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ContactsRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i3.HomeNavigation]
class HomeNavigation extends _i7.PageRouteInfo<void> {
  const HomeNavigation({List<_i7.PageRouteInfo>? children})
      : super(
          HomeNavigation.name,
          initialChildren: children,
        );

  static const String name = 'HomeNavigation';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i4.LoginScreen]
class LoginRoute extends _i7.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i8.Key? key,
    required void Function(bool) onAuthResult,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            onAuthResult: onAuthResult,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i7.PageInfo<LoginRouteArgs> page =
      _i7.PageInfo<LoginRouteArgs>(name);
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    required this.onAuthResult,
  });

  final _i8.Key? key;

  final void Function(bool) onAuthResult;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onAuthResult: $onAuthResult}';
  }
}

/// generated route for
/// [_i5.MyHomePage]
class MyHomeRoute extends _i7.PageRouteInfo<void> {
  const MyHomeRoute({List<_i7.PageRouteInfo>? children})
      : super(
          MyHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyHomeRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i6.ProfileScreen]
class ProfileRoute extends _i7.PageRouteInfo<void> {
  const ProfileRoute({List<_i7.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}
