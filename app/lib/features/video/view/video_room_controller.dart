import 'dart:async';

import 'package:chat_app/features/auth/application/user_access_service.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/user_access.dart';
import 'package:chat_app/features/video/data/stopwatch_repository.dart';
import 'package:chat_app/features/video/data/video_repository.dart';
import 'package:chat_app/features/video/data/video_timer_provider.dart';
import 'package:chat_app/features/video/domain/video_participant.dart';
import 'package:chat_app/features/video/domain/video_room_state.dart';
import 'package:chat_app/utils/logger.dart';
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

    _watchAppPaused();

    return VideoRoomState(
      localParticipant: videoRepository.localParticipant,
      remoteParticipants: videoRepository.remoteParticipants,
    );
  }

  void endCall({bool trialFinished = false}) async {
    _stopStopwatch();

    final videoRepository = await ref.read(videoRepositoryProvider.future);
    videoRepository.end();

    if (!isCaller) return;

    _updateAccess(trialFinished: trialFinished);
  }

  // * Callback Handlers

  void _onLocalParticipantJoin() async {
    ref.read(stopwatchRepositoryProvider).start();

    if (!isCaller) return;

    final userAccess = await ref.read(userAccessStreamProvider.future);
    if (userAccess == null) {
      logger.error(
        'UserAccess is null in VideoRoomController _onLocalParticipantJoin()',
        Error(),
        StackTrace.current,
      );
      return;
    }

    if (userAccess.level == AccessLevel.trial) {
      ref.read(videoTimerProvider.notifier).setTimer(userAccess.levelDuration);
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

  void _watchAppPaused() async {
    AppLifecycleListener(onStateChange: (appLifecycleState) async {
      final oldState = await future;
      if (appLifecycleState == AppLifecycleState.paused) {
        state = AsyncData(oldState.copyWith(isAppPaused: true));
      }
    });
  }

  // * Private methods

  void _stopStopwatch() {
    ref.read(stopwatchRepositoryProvider).stop();
  }

  void _updateAccess({bool trialFinished = false}) async {
    final userAccess = await ref.read(userAccessStreamProvider.future);
    if (userAccess == null) {
      logger.error(
        'UserAccess is null in VideoRoomController _updateAccess()',
        Error(),
        StackTrace.current,
      );
      return;
    }

    if (userAccess.level == AccessLevel.trial) {
      final userAccessService =
          await ref.read(userAccessServiceProvider.future);
      if (userAccessService == null) {
        logger.error(
          'UserAccessService is null in VideoRoomController _updateAccess()',
          Error(),
          StackTrace.current,
        );
        return;
      }

      if (trialFinished) {
        userAccessService.updateAccessLevel();
      } else {
        final elapsedDuration = Duration(
            milliseconds:
                ref.read(stopwatchRepositoryProvider).elapsedMilliseconds);
        await userAccessService.updateAccessDuration(elapsedDuration);
      }
    }
  }
}
