import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:chat_app/features/home/data/channel_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'online_presences.g.dart';

const lobbyChannelName = 'lobby';

@Riverpod(keepAlive: true)
class OnlinePresences extends _$OnlinePresences {
  @override
  Map<String, OnlineState> build() {
    return {};
  }

  void updatePresences(List<OnlineState> onlineStates) {
    final Map<String, OnlineState> newState = {};
    for (final onlineState in onlineStates) {
      newState[onlineState.profileId] = onlineState;
    }
    state = newState;
  }
}

@Riverpod(keepAlive: true)
FutureOr<ChannelRepository> lobbySubscribedChannel(
    LobbySubscribedChannelRef ref, String channelName) async {
  final supabase = ref.watch(supabaseProvider);

  return await ChannelRepository.makeSubscribedChannel(
    supabase: supabase,
    channelName: channelName,
    ref: ref,
  );
}
