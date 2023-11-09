// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i16;
import 'package:chat_app/features/auth/domain/profile.dart' as _i19;
import 'package:chat_app/features/auth/view/auth/auth_form_state.dart' as _i18;
import 'package:chat_app/features/auth/view/auth/auth_screen.dart' as _i1;
import 'package:chat_app/features/auth/view/profile/private_profile_screen.dart'
    as _i8;
import 'package:chat_app/features/auth/view/profile/profile_navigation.dart'
    as _i9;
import 'package:chat_app/features/auth/view/profile/public_profile_screen.dart'
    as _i10;
import 'package:chat_app/features/auth/view/profile/settings_screen.dart'
    as _i12;
import 'package:chat_app/features/chat/view/chat_lobby_screen.dart' as _i2;
import 'package:chat_app/features/chat/view/chat_navigation.dart' as _i3;
import 'package:chat_app/features/chat/view/chat_room_screen.dart' as _i4;
import 'package:chat_app/features/explore/view/explore_navigation.dart' as _i5;
import 'package:chat_app/features/explore/view/explore_screen.dart' as _i6;
import 'package:chat_app/features/home/view/main_navigation.dart' as _i7;
import 'package:chat_app/features/home/view/tabs_navigation.dart' as _i13;
import 'package:chat_app/features/search/view/search_screen.dart' as _i11;
import 'package:chat_app/features/video/view/video_room_screen.dart' as _i14;
import 'package:chat_app/features/video/view/waiting_screen.dart' as _i15;
import 'package:flutter/material.dart' as _i17;

abstract class $AppRouter extends _i16.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i16.PageFactory> pagesMap = {
    AuthRoute.name: (routeData) {
      final args = routeData.argsAs<AuthRouteArgs>();
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AuthScreen(
          key: args.key,
          formType: args.formType,
          onAuthResult: args.onAuthResult,
        ),
      );
    },
    ChatLobbyRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ChatLobbyScreen(),
      );
    },
    ChatNavigation.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.ChatNavigation(),
      );
    },
    ChatRoomRoute.name: (routeData) {
      final args = routeData.argsAs<ChatRoomRouteArgs>();
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.ChatRoomScreen(
          key: args.key,
          roomId: args.roomId,
          otherProfileId: args.otherProfileId,
        ),
      );
    },
    ExploreNavigation.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.ExploreNavigation(),
      );
    },
    ExploreRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.ExploreScreen(),
      );
    },
    MainNavigation.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.MainNavigation(),
      );
    },
    PrivateProfileRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.PrivateProfileScreen(),
      );
    },
    ProfileNavigation.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.ProfileNavigation(),
      );
    },
    PublicProfileRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<PublicProfileRouteArgs>(
          orElse: () =>
              PublicProfileRouteArgs(profileId: pathParams.getString('id')));
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i10.PublicProfileScreen(
          key: args.key,
          profileId: args.profileId,
        ),
      );
    },
    SearchRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.SearchScreen(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.SettingsScreen(),
      );
    },
    TabsNavigation.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.TabsNavigation(),
      );
    },
    VideoRoomRoute.name: (routeData) {
      final args = routeData.argsAs<VideoRoomRouteArgs>();
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i14.VideoRoomScreen(
          key: args.key,
          videoRoomId: args.videoRoomId,
          otherProfile: args.otherProfile,
        ),
      );
    },
    WaitingRoute.name: (routeData) {
      final args = routeData.argsAs<WaitingRouteArgs>();
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.WaitingScreen(
          key: args.key,
          otherProfile: args.otherProfile,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AuthScreen]
class AuthRoute extends _i16.PageRouteInfo<AuthRouteArgs> {
  AuthRoute({
    _i17.Key? key,
    required _i18.AuthFormType formType,
    required void Function(bool) onAuthResult,
    List<_i16.PageRouteInfo>? children,
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

  static const _i16.PageInfo<AuthRouteArgs> page =
      _i16.PageInfo<AuthRouteArgs>(name);
}

class AuthRouteArgs {
  const AuthRouteArgs({
    this.key,
    required this.formType,
    required this.onAuthResult,
  });

  final _i17.Key? key;

  final _i18.AuthFormType formType;

  final void Function(bool) onAuthResult;

  @override
  String toString() {
    return 'AuthRouteArgs{key: $key, formType: $formType, onAuthResult: $onAuthResult}';
  }
}

/// generated route for
/// [_i2.ChatLobbyScreen]
class ChatLobbyRoute extends _i16.PageRouteInfo<void> {
  const ChatLobbyRoute({List<_i16.PageRouteInfo>? children})
      : super(
          ChatLobbyRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatLobbyRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i3.ChatNavigation]
class ChatNavigation extends _i16.PageRouteInfo<void> {
  const ChatNavigation({List<_i16.PageRouteInfo>? children})
      : super(
          ChatNavigation.name,
          initialChildren: children,
        );

  static const String name = 'ChatNavigation';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i4.ChatRoomScreen]
class ChatRoomRoute extends _i16.PageRouteInfo<ChatRoomRouteArgs> {
  ChatRoomRoute({
    _i17.Key? key,
    required String roomId,
    required String otherProfileId,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          ChatRoomRoute.name,
          args: ChatRoomRouteArgs(
            key: key,
            roomId: roomId,
            otherProfileId: otherProfileId,
          ),
          rawPathParams: {'id': roomId},
          initialChildren: children,
        );

  static const String name = 'ChatRoomRoute';

  static const _i16.PageInfo<ChatRoomRouteArgs> page =
      _i16.PageInfo<ChatRoomRouteArgs>(name);
}

class ChatRoomRouteArgs {
  const ChatRoomRouteArgs({
    this.key,
    required this.roomId,
    required this.otherProfileId,
  });

  final _i17.Key? key;

  final String roomId;

  final String otherProfileId;

  @override
  String toString() {
    return 'ChatRoomRouteArgs{key: $key, roomId: $roomId, otherProfileId: $otherProfileId}';
  }
}

/// generated route for
/// [_i5.ExploreNavigation]
class ExploreNavigation extends _i16.PageRouteInfo<void> {
  const ExploreNavigation({List<_i16.PageRouteInfo>? children})
      : super(
          ExploreNavigation.name,
          initialChildren: children,
        );

  static const String name = 'ExploreNavigation';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i6.ExploreScreen]
class ExploreRoute extends _i16.PageRouteInfo<void> {
  const ExploreRoute({List<_i16.PageRouteInfo>? children})
      : super(
          ExploreRoute.name,
          initialChildren: children,
        );

  static const String name = 'ExploreRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i7.MainNavigation]
class MainNavigation extends _i16.PageRouteInfo<void> {
  const MainNavigation({List<_i16.PageRouteInfo>? children})
      : super(
          MainNavigation.name,
          initialChildren: children,
        );

  static const String name = 'MainNavigation';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i8.PrivateProfileScreen]
class PrivateProfileRoute extends _i16.PageRouteInfo<void> {
  const PrivateProfileRoute({List<_i16.PageRouteInfo>? children})
      : super(
          PrivateProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'PrivateProfileRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i9.ProfileNavigation]
class ProfileNavigation extends _i16.PageRouteInfo<void> {
  const ProfileNavigation({List<_i16.PageRouteInfo>? children})
      : super(
          ProfileNavigation.name,
          initialChildren: children,
        );

  static const String name = 'ProfileNavigation';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i10.PublicProfileScreen]
class PublicProfileRoute extends _i16.PageRouteInfo<PublicProfileRouteArgs> {
  PublicProfileRoute({
    _i17.Key? key,
    required String profileId,
    List<_i16.PageRouteInfo>? children,
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

  static const _i16.PageInfo<PublicProfileRouteArgs> page =
      _i16.PageInfo<PublicProfileRouteArgs>(name);
}

class PublicProfileRouteArgs {
  const PublicProfileRouteArgs({
    this.key,
    required this.profileId,
  });

  final _i17.Key? key;

  final String profileId;

  @override
  String toString() {
    return 'PublicProfileRouteArgs{key: $key, profileId: $profileId}';
  }
}

/// generated route for
/// [_i11.SearchScreen]
class SearchRoute extends _i16.PageRouteInfo<void> {
  const SearchRoute({List<_i16.PageRouteInfo>? children})
      : super(
          SearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i12.SettingsScreen]
class SettingsRoute extends _i16.PageRouteInfo<void> {
  const SettingsRoute({List<_i16.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i13.TabsNavigation]
class TabsNavigation extends _i16.PageRouteInfo<void> {
  const TabsNavigation({List<_i16.PageRouteInfo>? children})
      : super(
          TabsNavigation.name,
          initialChildren: children,
        );

  static const String name = 'TabsNavigation';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i14.VideoRoomScreen]
class VideoRoomRoute extends _i16.PageRouteInfo<VideoRoomRouteArgs> {
  VideoRoomRoute({
    _i17.Key? key,
    required String videoRoomId,
    required _i19.Profile otherProfile,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          VideoRoomRoute.name,
          args: VideoRoomRouteArgs(
            key: key,
            videoRoomId: videoRoomId,
            otherProfile: otherProfile,
          ),
          initialChildren: children,
        );

  static const String name = 'VideoRoomRoute';

  static const _i16.PageInfo<VideoRoomRouteArgs> page =
      _i16.PageInfo<VideoRoomRouteArgs>(name);
}

class VideoRoomRouteArgs {
  const VideoRoomRouteArgs({
    this.key,
    required this.videoRoomId,
    required this.otherProfile,
  });

  final _i17.Key? key;

  final String videoRoomId;

  final _i19.Profile otherProfile;

  @override
  String toString() {
    return 'VideoRoomRouteArgs{key: $key, videoRoomId: $videoRoomId, otherProfile: $otherProfile}';
  }
}

/// generated route for
/// [_i15.WaitingScreen]
class WaitingRoute extends _i16.PageRouteInfo<WaitingRouteArgs> {
  WaitingRoute({
    _i17.Key? key,
    required _i19.Profile otherProfile,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          WaitingRoute.name,
          args: WaitingRouteArgs(
            key: key,
            otherProfile: otherProfile,
          ),
          initialChildren: children,
        );

  static const String name = 'WaitingRoute';

  static const _i16.PageInfo<WaitingRouteArgs> page =
      _i16.PageInfo<WaitingRouteArgs>(name);
}

class WaitingRouteArgs {
  const WaitingRouteArgs({
    this.key,
    required this.otherProfile,
  });

  final _i17.Key? key;

  final _i19.Profile otherProfile;

  @override
  String toString() {
    return 'WaitingRouteArgs{key: $key, otherProfile: $otherProfile}';
  }
}
