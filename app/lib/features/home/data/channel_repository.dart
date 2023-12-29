import 'dart:async';

import 'package:chat_app/features/home/data/channel_presence_handlers.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'channel_repository.g.dart';

const lobbyChannelName = 'lobby';

class ChannelRepository {
  ChannelRepository({
    required this.supabase,
    required this.channelName,
    required this.ref,
  }) : channel = supabase.channel(channelName) {
    onJoin();
    onLeave();
  }

  final SupabaseClient supabase;
  final RealtimeChannel channel;
  final String channelName;
  final Ref ref;

  void on(String event, void Function(Map<String, dynamic> payload) callback) {
    channel.on(
        RealtimeListenTypes.broadcast,
        ChannelFilter(
          event: event,
        ), (data, [ref]) {
      // Sometimes the API puts the data in a subkey payload or other times not.
      final Map<String, dynamic> payload =
          data.containsKey('payload') ? data['payload'] : data;

      logger.i('${channel.subTopic} | Received  | $event : $payload');
      callback(payload);
    });
  }

  void off(String event) {
    channel.off('broadcast', {'event': event});
    logger.i('${channel.subTopic} | Terminated  | $event');
  }

  void send(String event, {Map<String, dynamic>? payload}) {
    channel.send(
      type: RealtimeListenTypes.broadcast,
      event: event,
      payload: payload ?? {},
    );
    logger.i('${channel.subTopic} | Sent | $event');
  }

  Future<void> close() async {
    try {
      await channel.unsubscribe(const Duration(minutes: 1));
    } catch (error, st) {
      await logError('close()', error, st);
      rethrow;
    }
  }
}

@riverpod
ChannelRepository channelRepository(
    ChannelRepositoryRef ref, String channelName) {
  final supabase = ref.watch(supabaseProvider);
  final channel =
      ChannelRepository(supabase: supabase, channelName: channelName, ref: ref);

  ref.onDispose(() => channel.close());

  return channel;
}

@riverpod
FutureOr<ChannelRepository> userSubscribedChannel(
    UserSubscribedChannelRef ref, String userId) async {
  final userChannel = ref.watch(channelRepositoryProvider(userId));
  userChannel.onUpdate();
  await userChannel.subscribed();
  return userChannel;
}

@riverpod
FutureOr<ChannelRepository> lobbySubscribedChannel(
    LobbySubscribedChannelRef ref) async {
  final lobbyChannel = ref.watch(channelRepositoryProvider(lobbyChannelName));
  await lobbyChannel.subscribed();
  return lobbyChannel;
}
