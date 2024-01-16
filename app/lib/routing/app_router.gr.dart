// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i25;
import 'package:chat_app/common/error_talker_screen.dart' as _i7;
import 'package:chat_app/features/auth/domain/profile.dart' as _i28;
import 'package:chat_app/features/auth/view/auth/auth_form_state.dart' as _i27;
import 'package:chat_app/features/auth/view/auth/auth_navigation.dart' as _i1;
import 'package:chat_app/features/auth/view/auth/auth_screen.dart' as _i2;
import 'package:chat_app/features/auth/view/auth/auth_verify_screen.dart'
    as _i3;
import 'package:chat_app/features/auth/view/auth/forgot_password_screen.dart'
    as _i10;
import 'package:chat_app/features/auth/view/auth/reset_password_screen.dart'
    as _i17;
import 'package:chat_app/features/auth/view/auth/signedup_screen_one.dart'
    as _i20;
import 'package:chat_app/features/auth/view/auth/signedup_screen_two.dart'
    as _i21;
import 'package:chat_app/features/auth/view/profile/private_profile_screen.dart'
    as _i13;
import 'package:chat_app/features/auth/view/profile/profile_edit_screen.dart'
    as _i14;
import 'package:chat_app/features/auth/view/profile/profile_navigation.dart'
    as _i15;
import 'package:chat_app/features/auth/view/profile/public_profile_screen.dart'
    as _i16;
import 'package:chat_app/features/auth/view/profile/settings_screen.dart'
    as _i19;
import 'package:chat_app/features/chat/view/chat_navigation.dart' as _i5;
import 'package:chat_app/features/chat/view/chat_room_screen.dart' as _i6;
import 'package:chat_app/features/chat_lobby/view/chat_lobby_screen.dart'
    as _i4;
import 'package:chat_app/features/explore/view/explore_navigation.dart' as _i8;
import 'package:chat_app/features/explore/view/explore_screen.dart' as _i9;
import 'package:chat_app/features/home/view/main_navigation.dart' as _i11;
import 'package:chat_app/features/home/view/tabs_navigation.dart' as _i22;
import 'package:chat_app/features/paywall/view/paywall_screen.dart' as _i12;
import 'package:chat_app/features/search/view/search_screen.dart' as _i18;
import 'package:chat_app/features/video/view/video_room_screen.dart' as _i23;
import 'package:chat_app/features/video/view/waiting_screen.dart' as _i24;
import 'package:flutter/material.dart' as _i26;

abstract class $AppRouter extends _i25.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i25.PageFactory> pagesMap = {
    AuthNavigation.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AuthNavigation(),
      );
    },
    AuthRoute.name: (routeData) {
      final args = routeData.argsAs<AuthRouteArgs>();
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.AuthScreen(
          key: args.key,
          formType: args.formType,
          resolver: args.resolver,
        ),
      );
    },
    AuthVerifyRoute.name: (routeData) {
      final args = routeData.argsAs<AuthVerifyRouteArgs>();
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.AuthVerifyScreen(
          key: args.key,
          email: args.email,
          isResetPassword: args.isResetPassword,
        ),
      );
    },
    ChatLobbyRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.ChatLobbyScreen(),
      );
    },
    ChatNavigation.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.ChatNavigation(),
      );
    },
    ChatRoomRoute.name: (routeData) {
      final args = routeData.argsAs<ChatRoomRouteArgs>();
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.ChatRoomScreen(
          key: args.key,
          roomId: args.roomId,
          otherProfileId: args.otherProfileId,
        ),
      );
    },
    ErrorTalkerRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.ErrorTalkerScreen(),
      );
    },
    ExploreNavigation.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.ExploreNavigation(),
      );
    },
    ExploreRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.ExploreScreen(),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.ForgotPasswordScreen(),
      );
    },
    MainNavigation.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.MainNavigation(),
      );
    },
    PaywallRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.PaywallScreen(),
      );
    },
    PrivateProfileRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.PrivateProfileScreen(),
      );
    },
    ProfileEditRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileEditRouteArgs>();
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i14.ProfileEditScreen(
          key: args.key,
          profile: args.profile,
        ),
      );
    },
    ProfileNavigation.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.ProfileNavigation(),
      );
    },
    PublicProfileRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<PublicProfileRouteArgs>(
          orElse: () =>
              PublicProfileRouteArgs(profileId: pathParams.getString('id')));
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i16.PublicProfileScreen(
          key: args.key,
          profileId: args.profileId,
        ),
      );
    },
    ResetPasswordRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i17.ResetPasswordScreen(),
      );
    },
    SearchRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i18.SearchScreen(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i19.SettingsScreen(),
      );
    },
    SignedupRouteOne.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i20.SignedupScreenOne(),
      );
    },
    SignedupRouteTwo.name: (routeData) {
      final args = routeData.argsAs<SignedupRouteTwoArgs>();
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i21.SignedupScreenTwo(
          key: args.key,
          updateProfile: args.updateProfile,
        ),
      );
    },
    TabsNavigation.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i22.TabsNavigation(),
      );
    },
    VideoRoomRoute.name: (routeData) {
      final args = routeData.argsAs<VideoRoomRouteArgs>();
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i23.VideoRoomScreen(
          key: args.key,
          videoRoomId: args.videoRoomId,
          otherProfileId: args.otherProfileId,
          isCaller: args.isCaller,
        ),
      );
    },
    WaitingRoute.name: (routeData) {
      final args = routeData.argsAs<WaitingRouteArgs>();
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i24.WaitingScreen(
          key: args.key,
          otherProfileId: args.otherProfileId,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AuthNavigation]
class AuthNavigation extends _i25.PageRouteInfo<void> {
  const AuthNavigation({List<_i25.PageRouteInfo>? children})
      : super(
          AuthNavigation.name,
          initialChildren: children,
        );

  static const String name = 'AuthNavigation';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i2.AuthScreen]
class AuthRoute extends _i25.PageRouteInfo<AuthRouteArgs> {
  AuthRoute({
    _i26.Key? key,
    required _i27.AuthFormType formType,
    required _i25.NavigationResolver resolver,
    List<_i25.PageRouteInfo>? children,
  }) : super(
          AuthRoute.name,
          args: AuthRouteArgs(
            key: key,
            formType: formType,
            resolver: resolver,
          ),
          initialChildren: children,
        );

  static const String name = 'AuthRoute';

  static const _i25.PageInfo<AuthRouteArgs> page =
      _i25.PageInfo<AuthRouteArgs>(name);
}

class AuthRouteArgs {
  const AuthRouteArgs({
    this.key,
    required this.formType,
    required this.resolver,
  });

  final _i26.Key? key;

  final _i27.AuthFormType formType;

  final _i25.NavigationResolver resolver;

  @override
  String toString() {
    return 'AuthRouteArgs{key: $key, formType: $formType, resolver: $resolver}';
  }
}

/// generated route for
/// [_i3.AuthVerifyScreen]
class AuthVerifyRoute extends _i25.PageRouteInfo<AuthVerifyRouteArgs> {
  AuthVerifyRoute({
    _i26.Key? key,
    required String email,
    bool isResetPassword = false,
    List<_i25.PageRouteInfo>? children,
  }) : super(
          AuthVerifyRoute.name,
          args: AuthVerifyRouteArgs(
            key: key,
            email: email,
            isResetPassword: isResetPassword,
          ),
          initialChildren: children,
        );

  static const String name = 'AuthVerifyRoute';

  static const _i25.PageInfo<AuthVerifyRouteArgs> page =
      _i25.PageInfo<AuthVerifyRouteArgs>(name);
}

class AuthVerifyRouteArgs {
  const AuthVerifyRouteArgs({
    this.key,
    required this.email,
    this.isResetPassword = false,
  });

  final _i26.Key? key;

  final String email;

  final bool isResetPassword;

  @override
  String toString() {
    return 'AuthVerifyRouteArgs{key: $key, email: $email, isResetPassword: $isResetPassword}';
  }
}

/// generated route for
/// [_i4.ChatLobbyScreen]
class ChatLobbyRoute extends _i25.PageRouteInfo<void> {
  const ChatLobbyRoute({List<_i25.PageRouteInfo>? children})
      : super(
          ChatLobbyRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatLobbyRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i5.ChatNavigation]
class ChatNavigation extends _i25.PageRouteInfo<void> {
  const ChatNavigation({List<_i25.PageRouteInfo>? children})
      : super(
          ChatNavigation.name,
          initialChildren: children,
        );

  static const String name = 'ChatNavigation';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i6.ChatRoomScreen]
class ChatRoomRoute extends _i25.PageRouteInfo<ChatRoomRouteArgs> {
  ChatRoomRoute({
    _i26.Key? key,
    required String roomId,
    required String otherProfileId,
    List<_i25.PageRouteInfo>? children,
  }) : super(
          ChatRoomRoute.name,
          args: ChatRoomRouteArgs(
            key: key,
            roomId: roomId,
            otherProfileId: otherProfileId,
          ),
          initialChildren: children,
        );

  static const String name = 'ChatRoomRoute';

  static const _i25.PageInfo<ChatRoomRouteArgs> page =
      _i25.PageInfo<ChatRoomRouteArgs>(name);
}

class ChatRoomRouteArgs {
  const ChatRoomRouteArgs({
    this.key,
    required this.roomId,
    required this.otherProfileId,
  });

  final _i26.Key? key;

  final String roomId;

  final String otherProfileId;

  @override
  String toString() {
    return 'ChatRoomRouteArgs{key: $key, roomId: $roomId, otherProfileId: $otherProfileId}';
  }
}

/// generated route for
/// [_i7.ErrorTalkerScreen]
class ErrorTalkerRoute extends _i25.PageRouteInfo<void> {
  const ErrorTalkerRoute({List<_i25.PageRouteInfo>? children})
      : super(
          ErrorTalkerRoute.name,
          initialChildren: children,
        );

  static const String name = 'ErrorTalkerRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i8.ExploreNavigation]
class ExploreNavigation extends _i25.PageRouteInfo<void> {
  const ExploreNavigation({List<_i25.PageRouteInfo>? children})
      : super(
          ExploreNavigation.name,
          initialChildren: children,
        );

  static const String name = 'ExploreNavigation';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i9.ExploreScreen]
class ExploreRoute extends _i25.PageRouteInfo<void> {
  const ExploreRoute({List<_i25.PageRouteInfo>? children})
      : super(
          ExploreRoute.name,
          initialChildren: children,
        );

  static const String name = 'ExploreRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i10.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i25.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i25.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i11.MainNavigation]
class MainNavigation extends _i25.PageRouteInfo<void> {
  const MainNavigation({List<_i25.PageRouteInfo>? children})
      : super(
          MainNavigation.name,
          initialChildren: children,
        );

  static const String name = 'MainNavigation';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i12.PaywallScreen]
class PaywallRoute extends _i25.PageRouteInfo<void> {
  const PaywallRoute({List<_i25.PageRouteInfo>? children})
      : super(
          PaywallRoute.name,
          initialChildren: children,
        );

  static const String name = 'PaywallRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i13.PrivateProfileScreen]
class PrivateProfileRoute extends _i25.PageRouteInfo<void> {
  const PrivateProfileRoute({List<_i25.PageRouteInfo>? children})
      : super(
          PrivateProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'PrivateProfileRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i14.ProfileEditScreen]
class ProfileEditRoute extends _i25.PageRouteInfo<ProfileEditRouteArgs> {
  ProfileEditRoute({
    _i26.Key? key,
    required _i28.Profile profile,
    List<_i25.PageRouteInfo>? children,
  }) : super(
          ProfileEditRoute.name,
          args: ProfileEditRouteArgs(
            key: key,
            profile: profile,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileEditRoute';

  static const _i25.PageInfo<ProfileEditRouteArgs> page =
      _i25.PageInfo<ProfileEditRouteArgs>(name);
}

class ProfileEditRouteArgs {
  const ProfileEditRouteArgs({
    this.key,
    required this.profile,
  });

  final _i26.Key? key;

  final _i28.Profile profile;

  @override
  String toString() {
    return 'ProfileEditRouteArgs{key: $key, profile: $profile}';
  }
}

/// generated route for
/// [_i15.ProfileNavigation]
class ProfileNavigation extends _i25.PageRouteInfo<void> {
  const ProfileNavigation({List<_i25.PageRouteInfo>? children})
      : super(
          ProfileNavigation.name,
          initialChildren: children,
        );

  static const String name = 'ProfileNavigation';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i16.PublicProfileScreen]
class PublicProfileRoute extends _i25.PageRouteInfo<PublicProfileRouteArgs> {
  PublicProfileRoute({
    _i26.Key? key,
    required String profileId,
    List<_i25.PageRouteInfo>? children,
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

  static const _i25.PageInfo<PublicProfileRouteArgs> page =
      _i25.PageInfo<PublicProfileRouteArgs>(name);
}

class PublicProfileRouteArgs {
  const PublicProfileRouteArgs({
    this.key,
    required this.profileId,
  });

  final _i26.Key? key;

  final String profileId;

  @override
  String toString() {
    return 'PublicProfileRouteArgs{key: $key, profileId: $profileId}';
  }
}

/// generated route for
/// [_i17.ResetPasswordScreen]
class ResetPasswordRoute extends _i25.PageRouteInfo<void> {
  const ResetPasswordRoute({List<_i25.PageRouteInfo>? children})
      : super(
          ResetPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i18.SearchScreen]
class SearchRoute extends _i25.PageRouteInfo<void> {
  const SearchRoute({List<_i25.PageRouteInfo>? children})
      : super(
          SearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i19.SettingsScreen]
class SettingsRoute extends _i25.PageRouteInfo<void> {
  const SettingsRoute({List<_i25.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i20.SignedupScreenOne]
class SignedupRouteOne extends _i25.PageRouteInfo<void> {
  const SignedupRouteOne({List<_i25.PageRouteInfo>? children})
      : super(
          SignedupRouteOne.name,
          initialChildren: children,
        );

  static const String name = 'SignedupRouteOne';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i21.SignedupScreenTwo]
class SignedupRouteTwo extends _i25.PageRouteInfo<SignedupRouteTwoArgs> {
  SignedupRouteTwo({
    _i26.Key? key,
    required _i28.Profile updateProfile,
    List<_i25.PageRouteInfo>? children,
  }) : super(
          SignedupRouteTwo.name,
          args: SignedupRouteTwoArgs(
            key: key,
            updateProfile: updateProfile,
          ),
          initialChildren: children,
        );

  static const String name = 'SignedupRouteTwo';

  static const _i25.PageInfo<SignedupRouteTwoArgs> page =
      _i25.PageInfo<SignedupRouteTwoArgs>(name);
}

class SignedupRouteTwoArgs {
  const SignedupRouteTwoArgs({
    this.key,
    required this.updateProfile,
  });

  final _i26.Key? key;

  final _i28.Profile updateProfile;

  @override
  String toString() {
    return 'SignedupRouteTwoArgs{key: $key, updateProfile: $updateProfile}';
  }
}

/// generated route for
/// [_i22.TabsNavigation]
class TabsNavigation extends _i25.PageRouteInfo<void> {
  const TabsNavigation({List<_i25.PageRouteInfo>? children})
      : super(
          TabsNavigation.name,
          initialChildren: children,
        );

  static const String name = 'TabsNavigation';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i23.VideoRoomScreen]
class VideoRoomRoute extends _i25.PageRouteInfo<VideoRoomRouteArgs> {
  VideoRoomRoute({
    _i26.Key? key,
    required String videoRoomId,
    required String otherProfileId,
    bool isCaller = false,
    List<_i25.PageRouteInfo>? children,
  }) : super(
          VideoRoomRoute.name,
          args: VideoRoomRouteArgs(
            key: key,
            videoRoomId: videoRoomId,
            otherProfileId: otherProfileId,
            isCaller: isCaller,
          ),
          initialChildren: children,
        );

  static const String name = 'VideoRoomRoute';

  static const _i25.PageInfo<VideoRoomRouteArgs> page =
      _i25.PageInfo<VideoRoomRouteArgs>(name);
}

class VideoRoomRouteArgs {
  const VideoRoomRouteArgs({
    this.key,
    required this.videoRoomId,
    required this.otherProfileId,
    this.isCaller = false,
  });

  final _i26.Key? key;

  final String videoRoomId;

  final String otherProfileId;

  final bool isCaller;

  @override
  String toString() {
    return 'VideoRoomRouteArgs{key: $key, videoRoomId: $videoRoomId, otherProfileId: $otherProfileId, isCaller: $isCaller}';
  }
}

/// generated route for
/// [_i24.WaitingScreen]
class WaitingRoute extends _i25.PageRouteInfo<WaitingRouteArgs> {
  WaitingRoute({
    _i26.Key? key,
    required String otherProfileId,
    List<_i25.PageRouteInfo>? children,
  }) : super(
          WaitingRoute.name,
          args: WaitingRouteArgs(
            key: key,
            otherProfileId: otherProfileId,
          ),
          initialChildren: children,
        );

  static const String name = 'WaitingRoute';

  static const _i25.PageInfo<WaitingRouteArgs> page =
      _i25.PageInfo<WaitingRouteArgs>(name);
}

class WaitingRouteArgs {
  const WaitingRouteArgs({
    this.key,
    required this.otherProfileId,
  });

  final _i26.Key? key;

  final String otherProfileId;

  @override
  String toString() {
    return 'WaitingRouteArgs{key: $key, otherProfileId: $otherProfileId}';
  }
}
