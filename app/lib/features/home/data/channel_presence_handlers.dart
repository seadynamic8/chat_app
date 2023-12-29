import 'dart:async';

import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/data/channel_repository.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

extension ChannelPresenceHandlers on ChannelRepository {
  void onJoin([void Function(List<OnlineState> onlineStates)? callback]) {
    channel.on(RealtimeListenTypes.presence, ChannelFilter(event: 'join'),
        (payload, [ref]) {
      final newUserPresences = payload['newPresences'] as List<Presence>;
      final newUserIdentifiers = _getUserIdentifiers(newUserPresences);

      if (callback != null) {
        callback(newUserPresences
            .map((p) => OnlineState.fromMap(p.payload))
            .toList());
      }
      logger.t('${channel.subTopic} | ${newUserIdentifiers[0]} | Joined');
    });
  }

  void onLeave([void Function(List<OnlineState> onlineStates)? callback]) {
    channel.on(RealtimeListenTypes.presence, ChannelFilter(event: 'leave'),
        (payload, [ref]) {
      final leavingUserPresences = payload['leftPresences'] as List<Presence>;
      final leavingUserIdentifiers = _getUserIdentifiers(leavingUserPresences);

      if (callback != null) {
        callback(leavingUserPresences
            .map((p) => OnlineState.fromMap(p.payload))
            .toList());
      }
      logger.t('${channel.subTopic} | ${leavingUserIdentifiers[0]} | Left');
    });
  }

  void onUpdate(
      [void Function(Map<String, OnlineState> onlinePresences)? callback]) {
    channel.on(RealtimeListenTypes.presence, ChannelFilter(event: 'sync'),
        (payload, [ref]) {
      // payload is only: {event: sync} (so not useful,
      // need to call presenceState() to get updated presences)
      final onlinePresences = getPresences();

      if (callback != null) callback(onlinePresences);
    });
  }

  List<String> _getUserIdentifiers(List<Presence> presences) {
    return presences.fold<List<String>>([], (userIdentifiers, presence) {
      userIdentifiers.add(presence.payload['profileId'] as String);
      return userIdentifiers;
    });
  }

  Map<String, OnlineState> getPresences() {
    final Map<String, OnlineState> onlinePresences = {};
    channel.presenceState().forEach((presenceStateKey, onlineUserPresences) {
      onlineUserPresences.forEach((Presence presence) {
        final userId = presence.payload['profileId'] as String;
        onlinePresences[userId] = OnlineState.fromMap(presence.payload);
      });
    });

    logger.t('${channel.subTopic} | ${onlinePresences.keys} | Current Users');
    return onlinePresences;
  }

  Future<void> subscribed() async {
    final completer = Completer<void>();
    final currentUserId = ref.read(currentUserIdProvider)!;

    channel.subscribe((status, [ref]) async {
      if (status == 'SUBSCRIBED') {
        await updatePresence(currentUserId, OnlineStatus.online);
        logger.i('${channel.subTopic} | $currentUserId | Subscribed');

        completer.complete();
      } else {
        logger.t('${channel.subTopic} | $currentUserId | Status: $status');
      }
    });
    return await completer.future;
  }

  Future<void> updatePresence(String currentUserId, OnlineStatus status) async {
    try {
      await channel.track({
        'profileId': currentUserId,
        'status': status.name,
        'enteredAt': DateTime.now().toIso8601String(),
      });
    } catch (error, st) {
      await logError('updatePresence()', error, st);
      rethrow;
    }
  }
}
