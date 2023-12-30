import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/explore/application/explore_service.dart';
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
  FutureOr<List<Profile>> build() async {
    final lobbyChannel = await ref.watch(lobbySubscribedChannelProvider.future);

    lobbyChannel.onJoin(_onJoin);
    lobbyChannel.onLeave(_onLeave);

    final onlineUserIds = lobbyChannel.getOtherOnlineUserIds();

    return ref.read(exploreServiceProvider).getOtherOnlineProfiles(
          onlineUserIds,
          initialPage,
          numberOfUsersPerRequest + initialExtraUsers,
        );
  }

  void _onJoin(OnlineState onlineState) async {
    final oldState = await future;

    final profileIndex =
        oldState.indexWhere((profile) => profile.id == onlineState.profileId);

    if (!_profileFound(profileIndex)) {
      final newProfile = await ref
          .read(authRepositoryProvider)
          .getProfile(onlineState.profileId);

      state = AsyncData([newProfile, ...oldState]);
    }
  }

  void _onLeave(OnlineState onlineState) async {
    final oldState = await future;

    final profileIndex =
        oldState.indexWhere((profile) => profile.id == onlineState.profileId);

    if (_profileFound(profileIndex)) {
      oldState.removeAt(profileIndex);
      state = AsyncData([...oldState]);
    }
  }

  bool _profileFound(int existingProfileIndex) {
    return existingProfileIndex > -1;
  }
}
