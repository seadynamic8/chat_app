import 'dart:async';

import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/video/data/video_settings_provider.dart';
import 'package:chat_app/features/video/domain/device_info.dart';
import 'package:chat_app/features/video/domain/video_participant.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:videosdk/videosdk.dart' hide Stream;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_repository.g.dart';

class VideoRepository {
  VideoRepository({required this.videoRoom});

  late final Room videoRoom; // VideoSDK Room  (don't mixup with our chat Room)

  VideoRepository.createVideoRoom({
    required String videoRoomId,
    required String videoToken,
    required String displayName,
    required String currentUserId,
    bool micEnabled = true,
    bool camEnabled = true,
    int? defaultCameraIndex,
  }) {
    videoRoom = VideoSDK.createRoom(
      roomId: videoRoomId,
      token: videoToken,
      displayName: displayName,
      participantId: currentUserId,
      micEnabled: micEnabled,
      camEnabled: camEnabled,
      defaultCameraIndex: defaultCameraIndex ?? ((kIsWeb) ? 0 : 1),
    );

    videoRoom.on(Events.error, (error) {
      logger.e(
          "VIDEOSDK ERROR :: ${error['code']}  :: ${error['name']} :: ${error['message']}");
    });
  }

  VideoParticipant get localParticipant =>
      VideoParticipant(participant: videoRoom.localParticipant);

  Map<String, VideoParticipant> get remoteParticipants {
    return videoRoom.participants.map((id, participant) =>
        MapEntry(id, VideoParticipant(participant: participant)));
  }

  String? get selectedCamId => videoRoom.selectedCamId;

  List<DeviceInfo> get cameras {
    return videoRoom.getCameras().map((mdi) => DeviceInfo(mdi: mdi)).toList();
  }

  // * Join Call

  Future<void> join() async {
    try {
      await videoRoom.join();
    } catch (error, st) {
      logger.error('join()', error, st);
      throw Exception('Unable to join video call'.i18n);
    }
  }

  // * Events

  void onLocalParticipantJoin([void Function()? callback]) {
    videoRoom.on(Events.roomJoined, () {
      logger.i('Video Room joined');
      if (callback != null) callback();
    });
  }

  void onLocalParticipantLeft([void Function()? callback]) {
    videoRoom.on(Events.roomLeft, () {
      logger.i('Video Room left');
      if (callback != null) callback();
    });
  }

  void onRemoteParticipantJoin(
      void Function(VideoParticipant videoParticipant) callback) {
    videoRoom.on(Events.participantJoined, (Participant participant) {
      if (!participant.isLocal) {
        callback(VideoParticipant(participant: participant));
      }
    });
  }

  void onRemoteParticipantLeft(
      void Function(String videoParticipantId) callback) {
    videoRoom.on(Events.participantLeft, (String participantId) {
      callback(participantId);
    });
  }

  // * End call

  // This just removes the current participant from the video room.
  void leave() async {
    try {
      videoRoom.leave();
    } catch (error, st) {
      logger.error('leave()', error, st);
    }
  }

  // * This ends the whole call, all participants are forced to leave.
  // * Usally what we want since, otherwise the room and stream stays open.
  void end() async {
    try {
      videoRoom.end();
    } catch (error, st) {
      logger.error('end()', error, st);
    }
  }

  // * Actions

  Future<void> muteMic() async {
    await videoRoom.muteMic();
    try {} catch (error, st) {
      logger.error('muteMic()', error, st);
      throw Exception('Unable to mute microphone'.i18n);
    }
  }

  Future<void> unmuteMic() async {
    try {
      await videoRoom.unmuteMic();
    } catch (error, st) {
      logger.error('unmuteMic()', error, st);
      throw Exception('Unable to unmute microphone'.i18n);
    }
  }

  Future<void> disableCam() async {
    await videoRoom.disableCam();
    try {} catch (error, st) {
      logger.error('disableCam()', error, st);
      throw Exception('Something went wrong when disabling the camera'.i18n);
    }
  }

  Future<void> enableCam() async {
    try {
      await videoRoom.enableCam();
    } catch (error, st) {
      logger.error('enableCam()', error, st);
      throw Exception('Something went wrong when enabling the camera'.i18n);
    }
  }

  Future<void> changeCam(String deviceId) async {
    try {
      await videoRoom.changeCam(deviceId);
    } catch (error, st) {
      logger.error('changeCam()', error, st);
      throw Exception('Something went wrong when changing the camera'.i18n);
    }
  }
}

@riverpod
FutureOr<VideoRepository> videoRepository(VideoRepositoryRef ref) async {
  final currentProfile = await ref.watch(currentProfileStreamProvider.future);
  if (currentProfile == null) {
    throw Exception('Unable to create video room, user not signed in'.i18n);
  }
  final videoSettings = ref.watch(videoSettingsProvider);

  return VideoRepository.createVideoRoom(
    videoRoomId: videoSettings.roomId!,
    videoToken: videoSettings.token!,
    displayName: currentProfile.username!,
    currentUserId: currentProfile.id!,
  );
}
