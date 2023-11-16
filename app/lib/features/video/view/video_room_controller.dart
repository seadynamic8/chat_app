import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/video/data/video_repository.dart';
import 'package:chat_app/features/video/domain/video_participant.dart';
import 'package:chat_app/features/video/domain/video_room_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'video_room_controller.g.dart';

@riverpod
class VideoRoomController extends _$VideoRoomController {
  @override
  Future<VideoRoomState> build(String otherProfileId) async {
    final videoRepository = ref.watch(videoRepositoryProvider);

    videoRepository.onLocalParticipantJoin();

    videoRepository.onRemoteParticipantJoin(_addRemoteParticipant);
    videoRepository.onRemoteParticipantLeft(_removeRemoteParticipant);

    await videoRepository.join();

    final currentProfileId = ref.watch(authRepositoryProvider).currentUserId!;
    final profiles = await ref.watch(chatRepositoryProvider).getBothProfiles(
        currentProfileId: currentProfileId, otherProfileId: otherProfileId);

    WakelockPlus.enable();

    return VideoRoomState(
      localParticipant: videoRepository.localParticipant,
      remoteParticipants: videoRepository.remoteParticipants,
      profiles: profiles,
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

    state = AsyncData(oldState.copyWith(
      remoteParticipants: remoteParticipants,
      remoteJoined: true,
    ));
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
