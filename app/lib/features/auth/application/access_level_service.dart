import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/data/current_profile_provider.dart';
import 'package:chat_app/features/auth/domain/user_access.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'access_level_service.g.dart';

class AccessLevelService {
  AccessLevelService({required this.ref, required this.userAccess});

  final Ref ref;
  final UserAccess userAccess;

  // When timer ended, time to change access level
  Future<void> changeAccessLevel() async {
    final currentProfileId = ref.read(currentProfileProvider).id!;
    if (userAccess.level == AccessLevel.trial && userAccess.hasCredits) {
      await _changeAccessToPremium(currentProfileId);
    } else {
      await _changeAccessToStandard(currentProfileId);
    }
  }

  // free trial or credits not used up yet, update values
  Future<void> updateAccessDurationOrCredits(Duration elapsedDuration) async {
    final currentProfileId = ref.read(currentProfileProvider).id!;
    if (userAccess.level == AccessLevel.premium && userAccess.hasCredits) {
      await _updateCreditsByDuration(currentProfileId, elapsedDuration);
    } else {
      await _updateTrialDuration(currentProfileId, elapsedDuration);
    }
  }

  Future<void> updateAccessCredits(int quantity) async {
    final currentProfileId = ref.read(currentProfileProvider).id!;
    try {
      await ref.read(authRepositoryProvider).updateAccessLevel(
            currentProfileId,
            userAccess.copyWith(
                level: AccessLevel.premium, // -> only needed first time
                credits: userAccess.credits + quantity),
          );
    } catch (error) {
      logger.e('AccessLevelService updateAccessCredits() error: $error');
      rethrow;
    }
  }

  // * Private methods

  Future<void> _changeAccessToPremium(String currentProfileId) async {
    await ref.read(authRepositoryProvider).updateAccessLevel(
          currentProfileId,
          userAccess.copyWith(
            level: AccessLevel.premium,
            trialDuration: Duration.zero,
          ),
        );
  }

  Future<void> _changeAccessToStandard(String currentProfileId) async {
    await ref.read(authRepositoryProvider).updateAccessLevel(
          currentProfileId,
          userAccess.copyWith(
            level: AccessLevel.standard,
            trialDuration: Duration.zero,
            credits: userAccess.level == AccessLevel.premium ? 0 : null,
          ),
        );
  }

  Future<void> _updateCreditsByDuration(
    String currentProfileId,
    Duration elapsedDuration,
  ) async {
    final elapsedCredits = UserAccess.creditsFromDuration(elapsedDuration);
    final remainingCredits = userAccess.credits - elapsedCredits;

    await ref.read(authRepositoryProvider).updateAccessLevel(
          currentProfileId,
          userAccess.copyWith(credits: remainingCredits),
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
  return AccessLevelService(ref: ref, userAccess: userAccess);
}
