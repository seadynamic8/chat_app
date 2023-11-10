import 'package:chat_app/features/video/data/video_repository.dart';
import 'package:chat_app/features/video/domain/video_controls_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_controls_controller.g.dart';

@riverpod
class VideoControlsController extends _$VideoControlsController {
  @override
  VideoControlsState build() {
    return VideoControlsState(
      allCameras: ref.watch(videoRepositoryProvider).cameras,
    );
  }

  Future<void> toggleMic() async {
    final videoRepository = ref.watch(videoRepositoryProvider);

    state.micEnabled
        ? await videoRepository.muteMic()
        : await videoRepository.unmuteMic();

    state = state.copyWith(micEnabled: !state.micEnabled);
  }

  Future<void> toggleCamera() async {
    final videoRepository = ref.watch(videoRepositoryProvider);

    state.camEnabled
        ? await videoRepository.disableCam()
        : await videoRepository.enableCam();

    state = state.copyWith(camEnabled: !state.camEnabled);
  }

  Future<void> switchNextCamera() async {
    if (state.allCameras.length < 2) return;

    final videoRepository = ref.read(videoRepositoryProvider);

    final selectedId = videoRepository.selectedCamId;
    final nextCamDeviceId = _findNextCameraDeviceId(selectedId!);

    await videoRepository.changeCam(nextCamDeviceId!);
  }

  String? _findNextCameraDeviceId(String selectedId) {
    final allCams = state.allCameras;
    final allCamsLength = allCams.length;

    var currentIndex = 0;
    while (currentIndex < allCamsLength) {
      final curCam = allCams[currentIndex];

      if (curCam.deviceId == selectedId) {
        var nextIndex = currentIndex + 1;
        if (nextIndex == allCamsLength) {
          nextIndex = 0;
        }
        return allCams[nextIndex].deviceId;
      }
      currentIndex += 1;
    }
    return null;
  }
}
