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

  void onUpdate([void Function(List<OnlineState> onlineStates)? callback]) {
    channel.on(RealtimeListenTypes.presence, ChannelFilter(event: 'sync'),
        (payload, [ref]) {
      final onlineStates = getPresences();

      if (callback != null) callback(onlineStates);
    });
  }

  List<String> _getUserIdentifiers(List<Presence> presences) {
    return presences.fold<List<String>>([], (userIdentifiers, presence) {
      userIdentifiers.add(presence.payload['profileId'] as String);
      return userIdentifiers;
    });
  }

  List<OnlineState> getPresences() {
    final userIds = [];
    final List<OnlineState> onlineStates = [];
    channel.presenceState().forEach((presenceStateKey, onlineUserPresences) {
      onlineUserPresences.forEach((Presence presence) {
        userIds.add(presence.payload['profileId'] as String);

        onlineStates.add(OnlineState.fromMap(presence.payload));
      });
    });

    logger.t('${channel.subTopic} | $userIds | Current Users');
    return onlineStates;
  }

  Future<void> subscribed() async {
    final completer = Completer<void>();
    final currentUserId = ref.read(currentUserIdProvider)!;

    channel.subscribe((status, [ref]) async {
      if (status == 'SUBSCRIBED') {
        udpatePresence(currentUserId, OnlineStatus.online);
        logger.i('${channel.subTopic} | $currentUserId | Subscribed');

        completer.complete();
      } else {
        logger.t('${channel.subTopic} | $currentUserId | Status: $status');
      }
    });
    return completer.future;
  }

  Future<void> udpatePresence(String currentUserId, OnlineStatus status) async {
    await channel.track({
      'profileId': currentUserId,
      'status': status.name,
      'enteredAt': DateTime.now().toIso8601String(),
    });
  }
}
