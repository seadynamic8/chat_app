import 'dart:async';

import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'channel_repository.g.dart';

class ChannelRepository {
  ChannelRepository({
    required this.supabase,
    required this.channelName,
  }) : channel = supabase.channel(channelName) {
    channel
      ..onError(_errorHandler)
      ..on(
        RealtimeListenTypes.presence,
        ChannelFilter(event: 'join'),
        _joinHandler,
      )
      ..on(
        RealtimeListenTypes.presence,
        ChannelFilter(event: 'leave'),
        _leaveHandler,
      )
      ..on(
        RealtimeListenTypes.presence,
        ChannelFilter(event: 'sync'),
        _updateHandler,
      );
  }

  final SupabaseClient supabase;
  final RealtimeChannel channel;
  final String channelName;

  void _errorHandler(String? error) {
    logger.w("${channel.subTopic} | Error :$error");
  }

  void _joinHandler(payload, [ref]) {
    final newUserPresences = payload['newPresences'] as List<Presence>;
    final newUserIdentifiers = _getUserIdentifiers(newUserPresences);

    logger.t('${channel.subTopic} | ${newUserIdentifiers[0]} | Joined');
  }

  void _leaveHandler(payload, [ref]) {
    final leavingUserPresences = payload['leftPresences'] as List<Presence>;
    final leavingUserIdentifiers = _getUserIdentifiers(leavingUserPresences);

    logger.t('${channel.subTopic} | ${leavingUserIdentifiers[0]} | Left');
  }

  void _updateHandler(payload, [ref]) {
    final userIds = [];
    channel.presenceState().forEach((presenceStateKey, onlineUserPresences) {
      onlineUserPresences.forEach((presence) {
        userIds.add(presence.payload['userIdentifier'] as String);
      });
    });
    logger.t('${channel.subTopic} | $userIds | Current Users');
  }

  List<String> _getUserIdentifiers(List<Presence> presences) {
    return presences.fold<List<String>>([], (userIdentifiers, presence) {
      userIdentifiers.add(presence.payload['userIdentifier'] as String);
      return userIdentifiers;
    });
  }

  Future<void> subscribed() {
    logger.t('subscribe ${channel.subTopic}: init()');

    final completer = Completer<void>();

    channel.subscribe((status, [ref]) async {
      final currentUsername =
          supabase.auth.currentUser!.userMetadata!['username'];

      if (status == 'SUBSCRIBED') {
        await channel.track({
          'userIdentifier': currentUsername,
          'status': status,
          'enteredAt': DateTime.now().toIso8601String(),
        });
        logger.i('${channel.subTopic} | $currentUsername | Subscribed');

        completer.complete();
      } else {
        logger.t('${channel.subTopic} | $currentUsername | Status: $status');
      }
    });
    logger.t('subscribe ${channel.subTopic}: finished');

    return completer.future;
  }

  void on(String event, void Function(Map<String, dynamic> payload) callback) {
    logger.i('setting on handler: ${channel.subTopic}: $event');
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
    logger.i('unsubscribe channel: ${channel.subTopic}');

    await channel.unsubscribe(const Duration(minutes: 1));
  }
}

@Riverpod(keepAlive: true)
ChannelRepository channelRepository(
    ChannelRepositoryRef ref, String channelName) {
  logger.t('channelRepository $channelName : init()');

  ref.onDispose(() {
    logger.t('channelRepository $channelName : dispose()');
  });

  final supabase = ref.watch(supabaseProvider);
  return ChannelRepository(supabase: supabase, channelName: channelName);
}
