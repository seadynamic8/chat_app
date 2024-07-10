import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/block_state.dart';
import 'package:chat_app/features/auth/domain/user_access.dart';
import 'package:chat_app/features/chat/data/joined_room_notifier.dart';
import 'package:chat_app/features/chat_lobby/data/chat_lobby_repository.dart';
import 'package:chat_app/features/home/application/online_presence_provider.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:chat_app/features/video/domain/call_availability.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'call_availability_provider.g.dart';

@riverpod
class CallAvailability extends _$CallAvailability {
  @override
  FutureOr<CallAvailabilityState> build(String otherProfileId) async {
    try {
      final isUnavaliable = await _getOnlineStatus(otherProfileId);
      if (isUnavaliable != null) return isUnavaliable;

      final isNotJoined = await _getJoinedStatus(otherProfileId);
      if (isNotJoined != null) return isNotJoined;

      final isBlocked = await _getBlockState(otherProfileId);
      if (isBlocked != null) return isBlocked;

      final isStandardLevel = await _getAccessLevel();
      if (isStandardLevel != null) return isStandardLevel;

      return CallAvailabilityState(
          status: CallAvailabilityStatus.canCall, data: null);
    } catch (error, st) {
      logger.error('build()', error, st);
      rethrow;
    }
  }

  Future<CallAvailabilityState?> _getOnlineStatus(String otherProfileId) async {
    final userStatus =
        await ref.watch(onlinePresenceProvider(otherProfileId).future);
    if (userStatus != OnlineStatus.online) {
      return CallAvailabilityState(
          status: CallAvailabilityStatus.unavailable, data: userStatus);
    }
    return null;
  }

  Future<CallAvailabilityState?> _getJoinedStatus(String otherProfileId) async {
    final room =
        await ref.watch(findRoomWithUserProvider(otherProfileId).future);
    if (room == null) {
      return CallAvailabilityState(
          status: CallAvailabilityStatus.notJoined, data: null);
    }

    final isJoined = await ref
        .watch(joinedRoomNotifierProvider(room.id, otherProfileId).future);
    if (!isJoined) {
      return CallAvailabilityState(
          status: CallAvailabilityStatus.notJoined, data: null);
    }
    return null;
  }

  Future<CallAvailabilityState?> _getBlockState(String otherProfileId) async {
    final blockState =
        await ref.watch(blockedByChangesProvider(otherProfileId).future);
    if (blockState.status != BlockStatus.no) {
      return CallAvailabilityState(
          status: CallAvailabilityStatus.blocked, data: blockState);
    }
    return null;
  }

  Future<CallAvailabilityState?> _getAccessLevel() async {
    final userAccess = await ref.watch(userAccessStreamProvider.future);
    if (userAccess == null) return null;

    final accessLevel = userAccess.level;
    if (accessLevel == AccessLevel.standard) {
      return CallAvailabilityState(
          status: CallAvailabilityStatus.noCoins, data: accessLevel);
    }
    return null;
  }
}
