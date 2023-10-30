// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:chat_app/features/auth/presentation/auth/auth_form_state.dart'
    as _i10;
import 'package:chat_app/features/auth/presentation/auth/auth_screen.dart'
    as _i1;
import 'package:chat_app/features/auth/presentation/profile/profile_navigation.dart'
    as _i5;
import 'package:chat_app/features/auth/presentation/profile/profile_screen.dart'
    as _i6;
import 'package:chat_app/features/auth/presentation/profile/profile_settings_screen.dart'
    as _i7;
import 'package:chat_app/features/chat/presentation/chats_screen.dart' as _i2;
import 'package:chat_app/features/contacts/presentation/contacts_screen.dart'
    as _i3;
import 'package:chat_app/features/home/presentation/home_navigation.dart'
    as _i4;
import 'package:flutter/material.dart' as _i9;

abstract class $AppRouter extends _i8.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i8.PageFactory> pagesMap = {
    AuthRoute.name: (routeData) {
      final args = routeData.argsAs<AuthRouteArgs>();
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AuthScreen(
          key: args.key,
          formType: args.formType,
          onAuthResult: args.onAuthResult,
        ),
      );
    },
    ChatsRoute.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ChatsScreen(),
      );
    },
    ContactsRoute.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.ContactsScreen(),
      );
    },
    HomeNavigation.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.HomeNavigation(),
      );
    },
    ProfileNavigation.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.ProfileNavigation(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.ProfileScreen(),
      );
    },
    ProfileSettingsRoute.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.ProfileSettingsScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.AuthScreen]
class AuthRoute extends _i8.PageRouteInfo<AuthRouteArgs> {
  AuthRoute({
    _i9.Key? key,
    required _i10.AuthFormType formType,
    required void Function(bool) onAuthResult,
    List<_i8.PageRouteInfo>? children,
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

  static const _i8.PageInfo<AuthRouteArgs> page =
      _i8.PageInfo<AuthRouteArgs>(name);
}

class AuthRouteArgs {
  const AuthRouteArgs({
    this.key,
    required this.formType,
    required this.onAuthResult,
  });

  final _i9.Key? key;

  final _i10.AuthFormType formType;

  final void Function(bool) onAuthResult;

  @override
  String toString() {
    return 'AuthRouteArgs{key: $key, formType: $formType, onAuthResult: $onAuthResult}';
  }
}

/// generated route for
/// [_i2.ChatsScreen]
class ChatsRoute extends _i8.PageRouteInfo<void> {
  const ChatsRoute({List<_i8.PageRouteInfo>? children})
      : super(
          ChatsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatsRoute';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i3.ContactsScreen]
class ContactsRoute extends _i8.PageRouteInfo<void> {
  const ContactsRoute({List<_i8.PageRouteInfo>? children})
      : super(
          ContactsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ContactsRoute';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i4.HomeNavigation]
class HomeNavigation extends _i8.PageRouteInfo<void> {
  const HomeNavigation({List<_i8.PageRouteInfo>? children})
      : super(
          HomeNavigation.name,
          initialChildren: children,
        );

  static const String name = 'HomeNavigation';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i5.ProfileNavigation]
class ProfileNavigation extends _i8.PageRouteInfo<void> {
  const ProfileNavigation({List<_i8.PageRouteInfo>? children})
      : super(
          ProfileNavigation.name,
          initialChildren: children,
        );

  static const String name = 'ProfileNavigation';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i6.ProfileScreen]
class ProfileRoute extends _i8.PageRouteInfo<void> {
  const ProfileRoute({List<_i8.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i7.ProfileSettingsScreen]
class ProfileSettingsRoute extends _i8.PageRouteInfo<void> {
  const ProfileSettingsRoute({List<_i8.PageRouteInfo>? children})
      : super(
          ProfileSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileSettingsRoute';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}
