import 'package:chat_app/common/pagination_state.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/home/data/channel_presence_handlers.dart';
import 'package:chat_app/features/home/data/channel_repository.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'explore_screen_controller.g.dart';

@riverpod
class ExploreScreenController extends _$ExploreScreenController {
  static const initialExtraUsers = 3;
  static const numberOfUsersPerRequest = 10;
  static const initialPage = 0;

  @override
  FutureOr<PaginationState<Profile>> build() async {
    final lobbyChannel = await ref.watch(lobbySubscribedChannelProvider.future);
    lobbyChannel.onJoin(_onJoin);
    lobbyChannel.onLeave(_onLeave);

    final otherOnlineProfiles = await ref
        .read(authRepositoryProvider)
        .getOtherOnlineProfiles(numberOfUsersPerRequest + initialExtraUsers);

    return PaginationState(
      lastOnlineAt: otherOnlineProfiles.last.onlineAt,
      items: otherOnlineProfiles,
    );
  }

  void getNextPageOfProfiles() async {
    final oldState = await future;

    final otherOnlineProfiles = await ref
        .read(authRepositoryProvider)
        .getOtherOnlineProfiles(numberOfUsersPerRequest, oldState.lastOnlineAt);

    final isLastPage = otherOnlineProfiles.length < numberOfUsersPerRequest;
    state = AsyncData(oldState.copyWith(
      isLastPage: isLastPage,
      lastOnlineAt: otherOnlineProfiles.last.onlineAt,
      items: [...oldState.items, ...otherOnlineProfiles],
    ));
  }

  void _onJoin(OnlineState onlineState) async {
    final oldState = await future;

    final profileIndex = oldState.items
        .indexWhere((profile) => profile.id == onlineState.profileId);

    if (!_profileFound(profileIndex)) {
      final newProfile = await ref
          .read(authRepositoryProvider)
          .getProfile(onlineState.profileId);

      state =
          AsyncData(oldState.copyWith(items: [newProfile, ...oldState.items]));
    }
  }

  void _onLeave(OnlineState onlineState) async {
    final oldState = await future;

    final profileIndex = oldState.items
        .indexWhere((profile) => profile.id == onlineState.profileId);

    if (_profileFound(profileIndex)) {
      oldState.items.removeAt(profileIndex);
      state = AsyncData(oldState.copyWith(items: [...oldState.items]));
    }
  }

  bool _profileFound(int existingProfileIndex) {
    return existingProfileIndex > -1;
  }
}
