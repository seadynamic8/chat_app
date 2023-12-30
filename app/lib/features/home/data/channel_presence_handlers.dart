import 'dart:async';

import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/data/channel_repository.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

extension ChannelPresenceHandlers on ChannelRepository {
  void onJoin([void Function(OnlineState onlineState)? callback]) {
    channel.on(RealtimeListenTypes.presence, ChannelFilter(event: 'join'),
        (payload, [ref]) {
      final newUserPresences = payload['newPresences'] as List<Presence>;
      final newUserIdentifiers = _getUserIdentifiers(newUserPresences);
      logger.t('${channel.subTopic} | ${newUserIdentifiers.first} | Joined');

      if (callback != null) {
        callback(OnlineState.fromMap(newUserPresences.first.payload));
      }
    });
  }

  void onLeave([void Function(OnlineState onlineState)? callback]) {
    channel.on(RealtimeListenTypes.presence, ChannelFilter(event: 'leave'),
        (payload, [ref]) {
      final leavingUserPresences = payload['leftPresences'] as List<Presence>;
      final leavingUserIdentifiers = _getUserIdentifiers(leavingUserPresences);
      logger.t('${channel.subTopic} | ${leavingUserIdentifiers.first} | Left');

      if (callback != null) {
        callback(OnlineState.fromMap(leavingUserPresences.first.payload));
      }
    });
  }

  void onUpdate(
      [void Function(Map<String, OnlineState> onlinePresences)? callback]) {
    channel.on(RealtimeListenTypes.presence, ChannelFilter(event: 'sync'),
        (payload, [ref]) {
      // payload is only: {event: sync} (so not useful,
      // need to call presenceState() to get updated presences)
      final onlinePresences = getPresences();
      logger.t('${channel.subTopic} | ${onlinePresences.keys} | Current Users');

      if (callback != null) callback(onlinePresences);
    });
  }

  // presenceState() returns something like:
  // { key : [ [ Presence ], [ Presence ], [ Presence ] ] }
  // key (not that useful for us),  and the outer list is an iterable
  // also, the presence.payload gives you actual details => Map<String, dynamic>

  Map<String, OnlineState> getPresences() {
    final Map<String, OnlineState> onlinePresences = {};
    channel.presenceState().forEach((presenceStateKey, onlineUserPresences) {
      onlineUserPresences.forEach((Presence presence) {
        final userId = presence.payload['profileId'] as String;
        onlinePresences[userId] = OnlineState.fromMap(presence.payload);
      });
    });
    return onlinePresences;
  }

  // No longer being used, but possible future uses, so won't remove for now
  List<String> getOtherOnlineUserIds() {
    final onlineUserPresences = channel.presenceState().values;
    final onlineStates = onlineUserPresences.fold<List<OnlineState>>([],
        (onlineStates, presenceList) {
      final presence = presenceList.first as Presence;
      onlineStates.add(OnlineState.fromMap(presence.payload));
      return onlineStates;
    });

    final sortedOnlineStates = _sortByEnteredAtDesc(onlineStates);
    final onlineUserIds = _getOnlineUserIds(sortedOnlineStates);
    final otherOnlineIds = _getOtherOnlineIds(onlineUserIds);
    return otherOnlineIds;
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
    final currentProfile = await ref.read(currentProfileStreamProvider.future);
    try {
      await channel.track({
        'profileId': currentUserId,
        'username':
            currentProfile?.username, // This field makes debugging easier
        'status': status.name,
        'enteredAt': DateTime.now().toIso8601String(),
      });
    } catch (error, st) {
      await logError('updatePresence()', error, st);
      rethrow;
    }
  }

  // * Private methods

  List<String> _getUserIdentifiers(List<Presence> presences) {
    return presences.fold<List<String>>([], (userIdentifiers, presence) {
      userIdentifiers.add(presence.payload['profileId'] as String);
      return userIdentifiers;
    });
  }

  List<OnlineState> _sortByEnteredAtDesc(List<OnlineState> onlineStates) {
    onlineStates.sort((a, b) => b.enteredAt.compareTo(a.enteredAt));
    return onlineStates;
  }

  List<String> _getOnlineUserIds(List<OnlineState> onlineStates) {
    return onlineStates.map((onlineState) => onlineState.profileId).toList();
  }

  List<String> _getOtherOnlineIds(List<String> onlineUserIds) {
    final currentUserId = ref.read(currentUserIdProvider)!;
    onlineUserIds.remove(currentUserId);
    return onlineUserIds;
  }
}
