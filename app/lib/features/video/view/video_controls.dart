import 'package:chat_app/features/video/view/video_controls_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class VideoControls extends ConsumerWidget {
  const VideoControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(videoControlsControllerProvider);
    final stateNotifier = ref.read(videoControlsControllerProvider.notifier);

    const iconShadow =
        Shadow(color: Colors.black54, blurRadius: 1, offset: Offset(0.3, 0.3));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () => stateNotifier.toggleMic(),
          icon: state.micEnabled
              ? const Icon(Icons.mic, shadows: [iconShadow])
              : const Icon(Icons.mic_off_outlined, shadows: [iconShadow]),
          color: Colors.white.withAlpha(150),
        ),
        IconButton(
          onPressed: () => stateNotifier.toggleCamera(),
          icon: state.camEnabled
              ? const Icon(Icons.camera_alt, shadows: [iconShadow])
              : const Icon(Icons.videocam_off_outlined, shadows: [iconShadow]),
          color: Colors.white.withAlpha(150),
        ),
        if (state.allCameras.length > 1)
          IconButton(
            onPressed: () => stateNotifier.switchNextCamera(),
            icon: const Icon(Icons.change_circle, shadows: [iconShadow]),
            color: Colors.white.withAlpha(150),
          ),
      ],
    );
  }
}
