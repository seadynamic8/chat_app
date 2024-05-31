import 'package:chat_app/features/home/data/channel_presence_handlers.dart';
import 'package:chat_app/features/home/data/channel_repository.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'online_presence_service.g.dart';

class OnlinePresenceService {
  OnlinePresenceService({required this.ref});

  final Ref ref;

  Future<void> updateCurrentUserPresence(OnlineStatus onlineStatus) async {
    try {
      final lobbyChannel =
          await ref.read(lobbySubscribedChannelProvider.future);
      await lobbyChannel.updatePresence(onlineStatus);
    } catch (error, st) {
      logger.error('updateCurrentUserPresence()', error, st);
      rethrow;
    }
  }
}

@riverpod
OnlinePresenceService onlinePresenceService(OnlinePresenceServiceRef ref) {
  return OnlinePresenceService(ref: ref);
}
