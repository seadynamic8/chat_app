import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VideoControls extends ConsumerWidget {
  const VideoControls({
    super.key,
    required this.onEndCall,
    required this.onToggleMic,
    required this.onToggleCamera,
    required this.onSwitchNextCamera,
    // required this.allCameras,
    // required this.selectedCameraDeviceId,
    // required this.onChangeCamera,
  });

  final void Function() onEndCall;
  final void Function() onToggleMic;
  final void Function() onToggleCamera;
  final void Function() onSwitchNextCamera;
  // final List<MediaDeviceInfo>? allCameras;
  // final String? selectedCameraDeviceId;
  // final void Function(String deviceId) onChangeCamera;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final state = ref.watch(videoRoomProvider);
    const AsyncValue state = AsyncData(null);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // IconButton(
        //   onPressed: onEndCall,
        //   icon: const Icon(Icons.call_end),
        // color: Colors.white.withAlpha(150),
        // ),
        IconButton(
          onPressed: state.isLoading ? null : onToggleMic,
          icon: !state.isLoading //&& state.value!.micEnabled
              ? const Icon(Icons.mic)
              : const Icon(Icons.mic_off_outlined),
          color: Colors.white.withAlpha(150),
        ),
        IconButton(
          onPressed: state.isLoading ? null : onToggleCamera,
          icon: !state.isLoading //&& state.value!.camEnabled
              ? const Icon(Icons.camera_alt)
              : const Icon(Icons.videocam_off_outlined),
          color: Colors.white.withAlpha(150),
        ),
        (kIsWeb)
            ?
            // allCameras == null || selectedCameraDeviceId == null
            //     ?
            IconButton(
                onPressed: null,
                icon: const Icon(Icons.change_circle),
                color: Colors.white.withAlpha(150),
              )
            // : DropdownMenu(
            //     dropdownMenuEntries: allCameras!
            //         .map(
            //           (camera) => DropdownMenuEntry(
            //               value: camera.deviceId, label: camera.label),
            //         )
            //         .toList(),
            //     initialSelection: selectedCameraDeviceId,
            //     onSelected: (deviceId) =>
            //         (deviceId != null) ? onChangeCamera(deviceId) : null,
            //   )
            : IconButton(
                onPressed: state.isLoading ? null : onSwitchNextCamera,
                icon: !state.isLoading
                    ? const Icon(Icons.change_circle)
                    : const Icon(Icons.change_circle_outlined),
                color: Colors.white.withAlpha(150),
              ),
      ],
    );
  }
}
