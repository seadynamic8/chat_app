import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_timer_provider.g.dart';

@riverpod
class VideoTimer extends _$VideoTimer {
  @override
  bool build() {
    return false;
  }

  Timer setTimer(Duration initialDuration) {
    return Timer(initialDuration, _handleTimerEnded);
  }

  void _handleTimerEnded() {
    state = true;
  }
}
