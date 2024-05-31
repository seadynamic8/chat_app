import 'dart:async';

import 'package:chat_app/features/home/data/channel_presence_handlers.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'channel_repository.g.dart';

const lobbyChannelName = 'lobby';

class ChannelRepository {
  ChannelRepository({
    required this.supabase,
    required this.channelName,
    required this.ref,
  }) : channel = supabase.channel(channelName);

  final SupabaseClient supabase;
  final RealtimeChannel channel;
  final String channelName;
  final Ref ref;

  void on(String event, void Function(Map<String, dynamic> payload) callback) {
    channel.onBroadcast(
      event: event,
      callback: (Map<String, dynamic> payload) {
        logger.i('$channelName | Received  | $event : $payload');
        callback(payload);
      },
    );
  }

  void send(String event, {Map<String, dynamic>? payload}) {
    channel.sendBroadcastMessage(
      event: event,
      payload: payload ?? {},
    );
    logger.i('$channelName | Sent | $event');
  }

  Future<void> close() async {
    try {
      await channel.unsubscribe(const Duration(minutes: 1));
    } catch (error, st) {
      logger.error('close()', error, st);
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
    UserSubscribedChannelRef ref, String userIdentifier) async {
  final userChannel = ref.watch(channelRepositoryProvider(userIdentifier));
  userChannel.onJoin();
  userChannel.onLeave();
  userChannel.onUpdate();
  await userChannel.subscribed();
  return userChannel;
}

@riverpod
FutureOr<ChannelRepository> lobbySubscribedChannel(
    LobbySubscribedChannelRef ref) async {
  final lobbyChannel = ref.watch(channelRepositoryProvider(lobbyChannelName));
  await lobbyChannel.subscribed();
  ref.read(authRepositoryProvider).setOnlineAt();
  return lobbyChannel;
}

@riverpod
Stream<Map<String, OnlineState>> lobbyUpdatePresenceStream(
    LobbyUpdatePresenceStreamRef ref, ChannelRepository lobbyChannel) {
  return lobbyChannel.onUpdate();
}
