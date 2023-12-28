import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/data/channel_presence_handlers.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:chat_app/features/home/data/channel_repository.dart';
import 'package:chat_app/utils/logger.dart';
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
    try {
      final lobbyChannel =
          await ref.read(lobbySubscribedChannelProvider.future);
      final currentUserId = ref.read(currentUserIdProvider)!;
      await lobbyChannel.updatePresence(currentUserId, onlineStatus);
    } catch (error, st) {
      await logError('updateCurrentUserPresence()', error, st);
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
FutureOr<ChannelRepository> lobbySubscribedChannel(
    LobbySubscribedChannelRef ref) async {
  final supabase = ref.watch(supabaseProvider);

  return await ChannelRepository.makeSubscribedChannel(
    supabase: supabase,
    channelName: lobbyChannelName,
    ref: ref,
  );
}
