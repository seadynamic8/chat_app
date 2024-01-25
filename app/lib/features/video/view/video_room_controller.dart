import 'dart:async';

import 'package:chat_app/features/auth/application/access_level_service.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/view/call_request_controller.dart';
import 'package:chat_app/features/video/data/stopwatch_repository.dart';
import 'package:chat_app/features/video/data/video_repository.dart';
import 'package:chat_app/features/video/data/video_timer_provider.dart';
import 'package:chat_app/features/video/domain/video_participant.dart';
import 'package:chat_app/features/video/domain/video_room_state.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'video_room_controller.g.dart';

@riverpod
class VideoRoomController extends _$VideoRoomController {
  @override
  Future<VideoRoomState> build(bool isCaller) async {
    // * Don't add any watchers here that can be refreshed, or else when refresh
    // * this will be rebuilt and video will re-join.  If you need to update
    // * state, u can do so with callback or 'listen'.  Or seperate out into
    // * seperate widget or another provider/controller.
    final videoRepository = await ref.watch(videoRepositoryProvider.future);

    videoRepository.onLocalParticipantJoin(_onLocalParticipantJoin);

    videoRepository.onRemoteParticipantJoin(_addRemoteParticipant);
    videoRepository.onRemoteParticipantLeft(_removeRemoteParticipant);

    await videoRepository.join();

    WakelockPlus.enable();

    watchAppPaused();

    return VideoRoomState(
      localParticipant: videoRepository.localParticipant,
      remoteParticipants: videoRepository.remoteParticipants,
    );
  }

  void watchAppPaused() async {
    AppLifecycleListener(onStateChange: (appLifecycleState) async {
      final oldState = await future;
      if (appLifecycleState == AppLifecycleState.paused) {
        state = AsyncData(oldState.copyWith(isAppPaused: true));
      }
    });
  }

  void endCall(String videoRoomId, String otherProfileId) async {
    ref
        .read(callRequestControllerProvider.notifier)
        .sendEndCall(videoRoomId, otherProfileId);

    final videoRepository = await ref.read(videoRepositoryProvider.future);
    videoRepository.end();
  }

  void changeAccessLevel() async {
    final accessLevelService =
        await ref.read(accessLevelServiceProvider.future);
    await accessLevelService.changeAccessLevel();
  }

  void updateAccessDurationOrCredits() async {
    final stopwatchRepository = ref.read(stopwatchRepositoryProvider);
    stopwatchRepository.stop();

    // timer is always set for a caller
    if (isCaller) {
      final elapsedDuration =
          Duration(milliseconds: stopwatchRepository.elapsedMilliseconds);
      final accessLevelService =
          await ref.read(accessLevelServiceProvider.future);

      await accessLevelService.updateAccessDurationOrCredits(elapsedDuration);
    }
  }

  // * Callback Handlers

  void _onLocalParticipantJoin() async {
    ref.read(stopwatchRepositoryProvider).start();

    if (!isCaller) return;

    final userAccess = await ref.read(userAccessStreamProvider.future);
    ref.read(videoTimerProvider.notifier).setTimer(userAccess.levelDuration);
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
}
