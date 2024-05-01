import 'package:chat_app/features/paywall/domain/product.dart';
import 'package:chat_app/utils/constants.dart';

enum AccessLevel { trial, standard, premium, free }

class UserAccess {
  UserAccess({
    required this.level,
    this.trialDuration,
  });

  final AccessLevel level;
  final Duration? trialDuration;

  bool get isNewTrial => trialDuration == null;
  bool get hasTrialDuration => trialDuration! != Duration.zero;

  Duration get levelDuration {
    if (isNewTrial) return newTrialDuration;
    if (hasTrialDuration) return remainingTrialDuration;
    throw Exception('incorrect level duration');
  }

  Duration get newTrialDuration => const Duration(minutes: trialMaxMins);
  Duration get remainingTrialDuration => newTrialDuration - trialDuration!;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'level': level.name,
      'trial_duration': trialDuration?.inMilliseconds,
    }..removeWhere((key, value) => value == null);
  }

  factory UserAccess.fromMap(Map<String, dynamic> map) {
    return UserAccess(
      level: AccessLevel.values.byName((map['level'] as String).trim()),
      trialDuration: map['trial_duration'] != null
          ? Duration(milliseconds: map['trial_duration'])
          : null,
    );
  }

  @override
  String toString() =>
      'UserAccess(level: $level, trialDuration: $trialDuration)';

  UserAccess copyWith({
    AccessLevel? level,
    Duration? trialDuration,
    Coins? credits,
  }) {
    return UserAccess(
      level: level ?? this.level,
      trialDuration: trialDuration ?? this.trialDuration,
    );
  }
}
