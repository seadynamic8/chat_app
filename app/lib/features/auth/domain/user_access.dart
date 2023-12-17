import 'package:chat_app/features/paywall/domain/product.dart';

enum AccessLevel { trial, standard, premium, free }

const trialMaxMins = 60;

class UserAccess {
  UserAccess({
    required this.level,
    this.trialDuration,
    required this.credits,
  });

  final AccessLevel level;
  final Duration? trialDuration;
  final Coins credits;

  static Coins creditsFromDuration(Duration duration) {
    return (duration.inSeconds / 60.0).ceil() * 10;
  }

  bool get isNewTrial => trialDuration == null;
  bool get hasTrialDuration => trialDuration! != Duration.zero;
  bool get hasCredits => credits > 0;

  Duration? get levelDuration {
    if (isNewTrial) return newTrialDuration;
    if (hasTrialDuration) return remainingTrialDuration;
    if (hasCredits) return durationFromCredits;
    return null;
  }

  Duration get newTrialDuration => const Duration(minutes: trialMaxMins);
  Duration get remainingTrialDuration => newTrialDuration - trialDuration!;
  Duration get durationFromCredits => Duration(minutes: credits ~/ 10);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'level': level.name,
      'trial_duration': trialDuration?.inMilliseconds,
      'credits': credits,
    }..removeWhere((key, value) => value == null);
  }

  factory UserAccess.fromMap(Map<String, dynamic> map) {
    return UserAccess(
      level: AccessLevel.values.byName((map['level'] as String).trim()),
      trialDuration: map['trial_duration'] != null
          ? Duration(milliseconds: map['trial_duration'])
          : null,
      credits: map['credits'],
    );
  }

  @override
  String toString() =>
      'UserAccess(level: $level, trialDuration: $trialDuration, credits: $credits)';

  UserAccess copyWith({
    AccessLevel? level,
    Duration? trialDuration,
    Coins? credits,
  }) {
    return UserAccess(
      level: level ?? this.level,
      trialDuration: trialDuration ?? this.trialDuration,
      credits: credits ?? this.credits,
    );
  }
}
