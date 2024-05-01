import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/user_access.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'access_level_service.g.dart';

class AccessLevelService {
  AccessLevelService(
      {required this.ref,
      required this.userAccess,
      required this.currentProfileId});

  final Ref ref;
  final UserAccess userAccess;
  final String currentProfileId;

  Future<void> updateAccessLevel() async {
    await _changeAccessToStandardAndResetDuration(currentProfileId);
  }

  Future<void> updateAccessDuration(Duration elapsedDuration) async {
    await _updateTrialDuration(currentProfileId, elapsedDuration);
  }

  Future<void> updateAccessToPremium() async {
    try {
      await ref.read(authRepositoryProvider).updateAccessLevel(
            currentProfileId,
            userAccess.copyWith(level: AccessLevel.premium),
          );
    } catch (error) {
      logger.e('AccessLevelService updateAccessToPremium() error: $error');
      rethrow;
    }
  }

  // * Private methods

  Future<void> _changeAccessToStandardAndResetDuration(
      String currentProfileId) async {
    await ref.read(authRepositoryProvider).updateAccessLevel(
          currentProfileId,
          userAccess.copyWith(
            level: AccessLevel.standard,
            trialDuration: Duration.zero,
          ),
        );
  }

  Future<void> _updateTrialDuration(
    String currentProfileId,
    Duration elapsedDuration,
  ) async {
    final beforeCallDuration = userAccess.trialDuration;
    final usedDuration = beforeCallDuration == null
        ? elapsedDuration
        : beforeCallDuration + elapsedDuration;

    await ref.read(authRepositoryProvider).updateAccessLevel(
          currentProfileId,
          userAccess.copyWith(trialDuration: usedDuration),
        );
  }
}

@riverpod
FutureOr<AccessLevelService> accessLevelService(
    AccessLevelServiceRef ref) async {
  final userAccess = await ref.watch(userAccessStreamProvider.future);
  final currentProfileId = ref.read(currentUserIdProvider)!;
  return AccessLevelService(
      ref: ref, userAccess: userAccess, currentProfileId: currentProfileId);
}
