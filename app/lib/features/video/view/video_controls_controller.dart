import 'package:chat_app/features/video/data/video_repository.dart';
import 'package:chat_app/features/video/domain/video_controls_state.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_controls_controller.g.dart';

@riverpod
class VideoControlsController extends _$VideoControlsController {
  @override
  FutureOr<VideoControlsState> build() async {
    final videoRepository = await ref.watch(videoRepositoryProvider.future);

    return VideoControlsState(allCameras: videoRepository.cameras);
  }

  Future<void> toggleMic() async {
    final videoRepository = await ref.watch(videoRepositoryProvider.future);

    final oldState = await future;
    oldState.micEnabled
        ? await videoRepository.muteMic()
        : await videoRepository.unmuteMic();

    state = AsyncData(oldState.copyWith(micEnabled: !oldState.micEnabled));
  }

  Future<void> toggleCamera() async {
    final videoRepository = await ref.watch(videoRepositoryProvider.future);

    final oldState = await future;
    oldState.camEnabled
        ? await videoRepository.disableCam()
        : await videoRepository.enableCam();

    state = AsyncData(oldState.copyWith(camEnabled: !oldState.camEnabled));
  }

  Future<void> switchNextCamera() async {
    final oldState = await future;
    if (oldState.allCameras.length < 2) return;

    final videoRepository = await ref.watch(videoRepositoryProvider.future);

    final selectedId = videoRepository.selectedCamId;
    final nextCamDeviceId = await _findNextCameraDeviceId(selectedId!);
    if (nextCamDeviceId == null) {
      logger.e('VideoControlsController nextCamDeviceId is null');
      return;
    }

    await videoRepository.changeCam(nextCamDeviceId);
  }

  Future<String?> _findNextCameraDeviceId(String selectedId) async {
    final oldState = await future;
    final allCams = oldState.allCameras;
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
