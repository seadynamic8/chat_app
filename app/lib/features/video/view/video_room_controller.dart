import 'dart:async';

import 'package:chat_app/features/auth/application/access_level_service.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/video/data/stopwatch_repository.dart';
import 'package:chat_app/features/video/data/video_repository.dart';
import 'package:chat_app/features/video/domain/video_participant.dart';
import 'package:chat_app/features/video/domain/video_room_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'video_room_controller.g.dart';

@riverpod
class VideoRoomController extends _$VideoRoomController {
  @override
  Future<VideoRoomState> build(
    String otherProfileId,
    bool isCaller,
  ) async {
    final videoRepository = ref.watch(videoRepositoryProvider);

    videoRepository.onLocalParticipantJoin(_onLocalParticipantJoin);
    videoRepository.onLocalParticipantLeft(_onLocalParticipantLeft);

    videoRepository.onRemoteParticipantJoin(_addRemoteParticipant);
    videoRepository.onRemoteParticipantLeft(_removeRemoteParticipant);

    await videoRepository.join();

    final profiles =
        await ref.watch(getProfilesForRoomProvider(otherProfileId).future);

    WakelockPlus.enable();

    return VideoRoomState(
      localParticipant: videoRepository.localParticipant,
      remoteParticipants: videoRepository.remoteParticipants,
      profiles: profiles,
    );
  }

  void endCall() {
    ref.read(videoRepositoryProvider).end();
  }

  // * Callback Handlers

  void _onLocalParticipantJoin() async {
    ref.read(stopwatchRepositoryProvider).start();

    if (!isCaller) return;

    final userAccess = await ref.watch(userAccessStreamProvider.future);

    final initialTimerDuration = userAccess.levelDuration;
    if (initialTimerDuration == null) return;

    final timer = Timer(initialTimerDuration, _handleTimeout);

    final oldState = await future;
    state = AsyncData(oldState.copyWith(timer: timer));
  }

  void _onLocalParticipantLeft() async {
    final stopwatchRepository = ref.read(stopwatchRepositoryProvider);
    stopwatchRepository.stop();

    // timer is always set for a caller
    if (isCaller) {
      final oldState = await future;

      final elapsedDuration =
          Duration(milliseconds: stopwatchRepository.elapsedMilliseconds);
      final accessLevelService =
          await ref.read(accessLevelServiceProvider.future);

      if (!oldState.timer!.isActive) {
        await accessLevelService.changeAccessLevel();
      } else {
        await accessLevelService.updateAccessDurationOrCredits(elapsedDuration);
        oldState.timer!.cancel();
      }
    }
  }

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

  void _handleTimeout() async {
    final oldState = await future;
    state = AsyncData(oldState.copyWith(timerEnded: true));
  }
}
