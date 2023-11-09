import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/data/channel_presence_handlers.dart';
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

  void updateAllPresences(List<OnlineState> onlineStates) {
    final Map<String, OnlineState> newState = {};
    for (final onlineState in onlineStates) {
      newState[onlineState.profileId] = onlineState;
    }
    state = newState;
  }

  Future<void> updateCurrentUserPresence(OnlineStatus onlineStatus) async {
    final lobbyChannel =
        await ref.read(lobbySubscribedChannelProvider(lobbyChannelName).future);
    final currentUserName = ref.read(authRepositoryProvider).currentUserName!;
    await lobbyChannel.udpatePresence(currentUserName, onlineStatus);
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
