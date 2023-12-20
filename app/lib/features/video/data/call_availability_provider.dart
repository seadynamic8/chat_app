import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/block_state.dart';
import 'package:chat_app/features/auth/domain/user_access.dart';
import 'package:chat_app/features/home/application/online_presences.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:chat_app/features/video/domain/call_availability.dart';
import 'package:chat_app/utils/user_online_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'call_availability_provider.g.dart';

@riverpod
class CallAvailability extends _$CallAvailability with UserOnlineStatus {
  @override
  FutureOr<CallAvailabilityState> build(String otherProfileId) async {
    final isUnavaliable = _getOnlineStatus(otherProfileId);
    if (isUnavaliable != null) return isUnavaliable;

    final isBlocked = await _getBlockState(otherProfileId);
    if (isBlocked != null) return isBlocked;

    final isStandardLevel = await _getAccessLevel();
    if (isStandardLevel != null) return isStandardLevel;

    return CallAvailabilityState(
        status: CallAvailabilityStatus.canCall, data: null);
  }

  CallAvailabilityState? _getOnlineStatus(String otherProfileId) {
    final onlinePresences = ref.watch(onlinePresencesProvider);
    final userStatus = getUserOnlineStatus(onlinePresences, otherProfileId);
    if (userStatus != OnlineStatus.online) {
      return CallAvailabilityState(
          status: CallAvailabilityStatus.unavailable, data: userStatus);
    }
    return null;
  }

  Future<CallAvailabilityState?> _getBlockState(String otherProfileId) async {
    final blockState =
        await ref.watch(isBlockedByEitherProvider(otherProfileId).future);
    if (blockState.status != BlockStatus.no) {
      return CallAvailabilityState(
          status: CallAvailabilityStatus.blocked, data: blockState);
    }
    return null;
  }

  Future<CallAvailabilityState?> _getAccessLevel() async {
    final accessLevel = await ref.watch(userAccessStreamProvider.future);
    if (accessLevel.level == AccessLevel.standard) {
      return CallAvailabilityState(
          status: CallAvailabilityStatus.noCoins, data: accessLevel);
    }
    return null;
  }
}