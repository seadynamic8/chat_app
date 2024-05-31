import 'package:chat_app/features/home/data/channel_presence_handlers.dart';
import 'package:chat_app/features/home/data/channel_repository.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'online_presence_provider.g.dart';

@riverpod
class OnlinePresence extends _$OnlinePresence {
  @override
  FutureOr<OnlineStatus> build(String userId) async {
    final lobbyChannel = await ref.watch(lobbySubscribedChannelProvider.future);
    final onlinePresences = lobbyChannel.getOnlinePresences();

    ref.listen<AsyncValue<Map<String, OnlineState>>>(
        lobbyUpdatePresenceStreamProvider(lobbyChannel), (_, onlinePresences) {
      onlinePresences.whenData((onlinePresences) {
        _updateNewPresence(onlinePresences);
      });
    });

    return !onlinePresences.containsKey(userId)
        ? OnlineStatus.offline
        : onlinePresences[userId]!.status;
  }

  void _updateNewPresence(Map<String, OnlineState> onlinePresences) async {
    final newStatus = onlinePresences[userId]?.status ?? OnlineStatus.offline;

    final oldState = await future;
    if (oldState != newStatus) {
      state = AsyncData(newStatus);
    }
  }
}
