import 'package:chat_app/features/video/data/stopwatch_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class VideoStopwatch extends ConsumerWidget {
  const VideoStopwatch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stopWatchStream = ref.watch(millisecondsStreamProvider);

    return stopWatchStream.maybeWhen(
      data: (milliseconds) => Container(
        decoration: const BoxDecoration(
          color: Colors.black38,
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Text(
            StopWatchTimer.getDisplayTime(
              milliseconds,
              milliSecond: false,
            ),
          ),
        ),
      ),
      orElse: SizedBox.shrink,
    );
  }
}
