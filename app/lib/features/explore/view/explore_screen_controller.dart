import 'package:chat_app/common/pagination_state.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/explore/view/application/explore_service.dart';
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
        .read(exploreServiceProvider)
        .getOtherOnlineProfiles(
            limit: numberOfUsersPerRequest + initialExtraUsers);

    return PaginationState(
      lastOnlineAt: otherOnlineProfiles.isEmpty
          ? null
          : otherOnlineProfiles.last.onlineAt,
      items: otherOnlineProfiles,
    );
  }

  void getNextPageOfProfiles() async {
    final oldState = await future;

    final otherOnlineProfiles = await ref
        .read(exploreServiceProvider)
        .getOtherOnlineProfiles(
            limit: numberOfUsersPerRequest,
            lastOnlineAt: oldState.lastOnlineAt);

    final isLastPage = otherOnlineProfiles.length < numberOfUsersPerRequest;
    state = AsyncData(oldState.copyWith(
      isLastPage: isLastPage,
      lastOnlineAt: otherOnlineProfiles.last.onlineAt,
      items: [...oldState.items, ...otherOnlineProfiles],
    ));
  }

  void _onJoin(OnlineState onlineState) async {
    if (_isCurrentUser(onlineState)) return;

    final oldState = await future;
    final profileIndex =
        _profileIndexOrNull(oldState.items, onlineState.profileId);
    if (profileIndex != null) return;

    final newProfile = await ref
        .read(authRepositoryProvider)
        .getProfile(onlineState.profileId);
    state = AsyncData(
      oldState.copyWith(
        items: [newProfile, ...oldState.items],
      ),
    );
  }

  void _onLeave(OnlineState onlineState) async {
    if (_isCurrentUser(onlineState)) return;
    if (await _isUserBusy(onlineState)) return;

    final oldState = await future;
    final profileIndex =
        _profileIndexOrNull(oldState.items, onlineState.profileId);
    if (profileIndex == null) return;

    oldState.items.removeAt(profileIndex);
    state = AsyncData(oldState.copyWith(items: [...oldState.items]));
  }

  int? _profileIndexOrNull(List<Profile> profiles, String profileId) {
    final profileIndex =
        profiles.indexWhere((profile) => profile.id == profileId);
    return _profileFound(profileIndex) ? profileIndex : null;
  }

  bool _profileFound(int existingProfileIndex) {
    return existingProfileIndex > -1;
  }

  bool _isCurrentUser(OnlineState onlineState) {
    return onlineState.profileId == ref.read(currentUserIdProvider)!;
  }

  // 2 cases:
  // - user goes from online -> busy (online:leave, busy:join)
  // - or from busy -> online        (busy: leave, online: join)
  // - There's a leave message generated, we don't want to remove user then.
  Future<bool> _isUserBusy(OnlineState onlineState) async {
    // leaving user is busy, means he's actually changing back to online (not leaving)
    if (onlineState.status == OnlineStatus.busy) return true;

    // if existing user was busy, means that someone already updated him to busy
    // and the leave message came late (=> he's changing to busy ultimately)
    // Also, we don't use onlinePresenceProvider for the data as the data
    // may not have updated yet (when both leave and update fire at same time)
    final lobbyChannel = await ref.read(lobbySubscribedChannelProvider.future);
    final onlinePresences = lobbyChannel.getOnlinePresences();
    // The '?' protects against user not being in the list at all.
    return onlinePresences[onlineState.profileId]?.status == OnlineStatus.busy;
  }
}
