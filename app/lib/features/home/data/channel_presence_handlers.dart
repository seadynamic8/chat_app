import 'dart:async';

import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/data/channel_repository.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// For some reason the logger using the currentUserStream is causing issues
// in the callbacks (concurrent modification errors), so the logger is
// called with (addUser: false) for now.

extension ChannelPresenceHandlers on ChannelRepository {
  void onJoin([void Function(OnlineState onlineState)? callback]) {
    channel.onPresenceJoin((RealtimePresenceJoinPayload payload) {
      try {
        final newUserPresences = payload.newPresences;
        final newUserIdentifiers = _getUserIdentifiers(newUserPresences);
        logger.t('$channelName | ${newUserIdentifiers.first} | Joined',
            addUser: false);

        if (callback != null) {
          callback(OnlineState.fromMap(newUserPresences.first.payload));
        }
      } catch (error, st) {
        logger.error('onJoin()', error, st);
      }
    });
  }

  void onLeave([void Function(OnlineState onlineState)? callback]) {
    channel.onPresenceLeave((RealtimePresenceLeavePayload payload) async {
      try {
        final leavingUserPresences = payload.leftPresences;

        final leavingUserIdentifiers =
            _getUserIdentifiers(leavingUserPresences);
        logger.t('$channelName | ${leavingUserIdentifiers.first} | Left',
            addUser: false);

        if (callback != null) {
          callback(OnlineState.fromMap(leavingUserPresences.first.payload));
        }
      } catch (error, st) {
        logger.error('onLeave()', error, st);
      }
    });
  }

  Stream<Map<String, OnlineState>> onUpdate() {
    final streamController = StreamController<Map<String, OnlineState>>();

    channel.onPresenceSync((RealtimePresenceSyncPayload payload) {
      try {
        // payload is only: PresenceSyncPayload(event: PresenceEvent.sync)
        // so not useful, need to call presenceState() to get updated presences
        final onlinePresences = getOnlinePresences();

        final usernames = onlinePresences.values
            .map((onlineState) => onlineState.username)
            .toList();
        logger.t('$channelName | $usernames | Current Users', addUser: false);

        streamController.add(onlinePresences);
      } catch (error, st) {
        logger.error('onUpdate()', error, st);
      }
    });
    return streamController.stream;
  }

  // presenceState() returns something like:
  // [ PresenceState(key: uuid, presences: [ Presence ]), ...]
  // key (not that useful for us)
  // Presence.payload gives you actual details => Map<String, dynamic>
  List<Presence> get presenceStates => channel
      .presenceState()
      .map((SinglePresenceState state) =>
          state.presences.first) // presences should always have one value
      .toList();

  Map<String, OnlineState> getOnlinePresences() {
    return presenceStates.fold<Map<String, OnlineState>>({},
        (onlinePresences, presence) {
      try {
        final userId = presence.payload['profileId'] as String;
        onlinePresences[userId] = OnlineState.fromMap(presence.payload);
        return onlinePresences;
      } catch (error, st) {
        logger.error('getOnlinePresences()', error, st);
        return {};
      }
    });
  }

  List<String> getOnlineUserIds({required int limit, DateTime? lastOnlineAt}) {
    try {
      List<String> onlineUserIds = [];

      for (final presence in presenceStates) {
        // reached limit (or range of page)
        if (onlineUserIds.length == limit) return onlineUserIds;

        final enteredAt = presence.payload['enteredAt'];

        // don't add newer online users (i.e. we want the older online
        // users based on the lastOnlineAt cursor)
        if (lastOnlineAt != null && enteredAt >= lastOnlineAt) continue;

        onlineUserIds.add(presence.payload['profileId'] as String);
      }
      return onlineUserIds;
    } catch (error, st) {
      logger.error('getOnlineUserIds()', error, st);
      return [];
    }
  }

  Future<void> subscribed() async {
    final completer = Completer<void>();

    channel.subscribe((status, error) async {
      try {
        if (status == RealtimeSubscribeStatus.subscribed) {
          await updatePresence(OnlineStatus.online);

          completer.complete();
        } else {
          logger.t('$channelName | Status: ${status.name}', addUser: false);
        }
      } catch (error, st) {
        logger.error('subscribed()', error, st);
      }
    });
    return await completer.future;
  }

  Future<void> updatePresence(OnlineStatus status) async {
    try {
      final currentProfile =
          await ref.read(currentProfileStreamProvider.future);
      if (currentProfile == null) return;

      await channel.track({
        'profileId': currentProfile.id,
        'username':
            currentProfile.username, // This field makes debugging easier
        'status': status.name,
        'enteredAt': DateTime.now().toUtc().toIso8601String(),
      });
      logger.i('$channelName | ${currentProfile.username} | Subscribed',
          addUser: false);
    } catch (error, st) {
      logger.error('updatePresence()', error, st);
      rethrow;
    }
  }

  // * Private methods

  List<String> _getUserIdentifiers(List<Presence> presences) {
    return presences.fold<List<String>>([], (userIdentifiers, presence) {
      userIdentifiers.add(presence.payload['username'] as String);
      return userIdentifiers;
    });
  }
}
