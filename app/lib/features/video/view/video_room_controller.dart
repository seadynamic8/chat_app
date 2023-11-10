import 'package:chat_app/features/video/data/video_repository.dart';
import 'package:chat_app/features/video/domain/video_participant.dart';
import 'package:chat_app/features/video/domain/video_room_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_room_controller.g.dart';

@riverpod
class VideoRoomController extends _$VideoRoomController {
  @override
  Future<VideoRoomState> build() async {
    final videoRepository = ref.watch(videoRepositoryProvider);

    videoRepository.onLocalParticipantJoin();

    videoRepository.onRemoteParticipantJoin(_addRemoteParticipant);
    videoRepository.onRemoteParticipantLeft(_removeRemoteParticipant);

    await videoRepository.join();

    return VideoRoomState(
      localParticipant: videoRepository.localParticipant,
      remoteParticipants: videoRepository.remoteParticipants,
    );
  }

  void endCall() {
    ref.watch(videoRepositoryProvider).end();
  }

  // * Callback Handlers

  void _addRemoteParticipant(VideoParticipant videoParticipant) async {
    final oldState = await future;
    state = const AsyncLoading();

    final remoteParticipants = {...oldState.remoteParticipants};
    remoteParticipants[videoParticipant.id] = videoParticipant;

    state =
        AsyncData(oldState.copyWith(remoteParticipants: remoteParticipants));
  }

  void _removeRemoteParticipant(String videoParticipantId) async {
    final oldState = await future;
    state = const AsyncLoading();

    final remoteParticipants = {...oldState.remoteParticipants};
    final participant = remoteParticipants.remove(videoParticipantId);

    if (participant != null) {
      state =
          AsyncData(oldState.copyWith(remoteParticipants: remoteParticipants));
    }
  }
}
