import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/data/channel_presence_handlers.dart';
import 'package:chat_app/features/home/domain/online_presences_state.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:chat_app/features/home/data/channel_repository.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'online_presences.g.dart';

// @Riverpod(keepAlive: true)
@riverpod
class OnlinePresences extends _$OnlinePresences {
  @override
  FutureOr<OnlinePresencesState> build() async {
    final lobbyChannel = await ref.watch(lobbySubscribedChannelProvider.future);
    final initialOnlinePresences = lobbyChannel.getPresences();

    lobbyChannel.onUpdate(updateAllPresences);

    return OnlinePresencesState(presences: initialOnlinePresences);
  }

  void updateAllPresences(Map<String, OnlineState> onlinePresences) async {
    state = AsyncData(OnlinePresencesState(presences: onlinePresences));
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
