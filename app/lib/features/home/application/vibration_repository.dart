import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibration/vibration.dart';

part 'vibration_repository.g.dart';

class VibrationRepository {
  VibrationRepository({required this.ref});

  final Ref ref;
  bool _cancel = false;

  Future<void> callVibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      if (await Vibration.hasCustomVibrationsSupport() ?? false) {
        if (await Vibration.hasAmplitudeControl() ?? false) {
          await Vibration.vibrate(
            pattern: [1000, 500, 1000, 500],
            repeat: 1,
            amplitude: 128,
          );
        } else {
          await Vibration.vibrate(
            pattern: [1000, 500, 1000, 500],
            repeat: 1,
            intensities: [1, 255],
          );
        }
      } else {
        await Vibration.vibrate(pattern: [1000, 500, 1000, 500], repeat: 1);
      }
      _manualTimerVibration();
    }
  }

  Future<void> cancelVibration() async {
    await Vibration.cancel();
    _cancel = true;
  }

  void _manualTimerVibration() {
    _cancel = false;
    Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      if (_cancel) {
        timer.cancel();
        _cancel = false;
        return;
      }
      await Vibration.vibrate();
    });
  }
}

@riverpod
VibrationRepository vibrationRepository(VibrationRepositoryRef ref) {
  return VibrationRepository(ref: ref);
}
