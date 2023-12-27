import 'dart:async';

import 'package:chat_app/features/home/data/channel_presence_handlers.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'channel_repository.g.dart';

class ChannelRepository {
  ChannelRepository({
    required this.supabase,
    required this.channelName,
    required this.ref,
    void Function(List<OnlineState> onlineStates)? updateCallback,
  }) : channel = supabase.channel(channelName) {
    onJoin();
    onLeave();
    onUpdate(updateCallback);
  }

  final SupabaseClient supabase;
  final RealtimeChannel channel;
  final String channelName;
  final Ref ref;

  static Future<ChannelRepository> makeSubscribedChannel({
    required supabase,
    required channelName,
    required ref,
    void Function(List<OnlineState> onlineStates)? updateCallback,
  }) async {
    try {
      final channelRepository = ChannelRepository(
          supabase: supabase,
          channelName: channelName,
          ref: ref,
          updateCallback: updateCallback);
      await channelRepository.subscribed();
      return channelRepository;
    } catch (error, st) {
      await logError('makeSubscribedChannel()', error, st);
      rethrow;
    }
  }

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

@Riverpod(keepAlive: true)
ChannelRepository channelRepository(
    ChannelRepositoryRef ref, String channelName) {
  final supabase = ref.watch(supabaseProvider);

  return ChannelRepository(
      supabase: supabase, channelName: channelName, ref: ref);
}
