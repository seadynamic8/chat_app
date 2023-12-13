import 'dart:async';

import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stopwatch_repository.g.dart';

class StopwatchRepository {
  final StopWatchTimer stopwatch = StopWatchTimer();

  int get elapsedMilliseconds => stopwatch.rawTime.value;

  void start() {
    stopwatch.onStartTimer();
  }

  void stop() {
    stopwatch.onStopTimer();
  }

  void reset() {
    stopwatch.onResetTimer();
  }

  // Make sure to call this at the end of using it
  void dispose() {
    stopwatch.dispose();
  }

  Stream<int> watchMilliseconds() async* {
    final streamController = StreamController<int>();
    stopwatch.rawTime.listen((int milliseconds) {
      streamController.add(milliseconds);
    });
    yield* streamController.stream;
  }
}

@riverpod
StopwatchRepository stopwatchRepository(StopwatchRepositoryRef ref) {
  final stopwatchRepository = StopwatchRepository();
  ref.onDispose(() => stopwatchRepository.dispose());
  return stopwatchRepository;
}

@riverpod
Stream<int> millisecondsStream(MillisecondsStreamRef ref) {
  return ref.watch(stopwatchRepositoryProvider).watchMilliseconds();
}
