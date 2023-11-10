import 'dart:async';

import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/video/data/video_settings_provider.dart';
import 'package:chat_app/features/video/domain/video_participant.dart';
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
  }

  VideoParticipant get localParticipant =>
      VideoParticipant(participant: videoRoom.localParticipant);

  Map<String, VideoParticipant> get remoteParticipants {
    return videoRoom.participants.map((id, participant) =>
        MapEntry(id, VideoParticipant(participant: participant)));
  }

  Future<void> join() async {
    await videoRoom.join();
  }

  void onLocalParticipantJoin([void Function()? callback]) {
    videoRoom.on(Events.roomJoined, () {
      logger.i('Video Room joined');
      if (callback != null) callback();
    });
  }

  void onLocalParticipantLeft([void Function()? callback]) {
    videoRoom.on(Events.roomJoined, () {
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

  // This just removes the current participant from the video room.
  void leave() {
    videoRoom.leave();
  }

  // * This ends the whole call, all participants are forced to leave.
  // * Usally what we want since, otherwise the room and stream stays open.
  void end() {
    videoRoom.end();
  }
}

@riverpod
VideoRepository videoRepository(VideoRepositoryRef ref) {
  final currentUserId = ref.watch(authRepositoryProvider).currentUserId!;
  final currentUserName = ref.watch(authRepositoryProvider).currentUserName!;
  final videoSettings = ref.watch(videoSettingsProvider);

  return VideoRepository.createVideoRoom(
    videoRoomId: videoSettings.roomId!,
    videoToken: videoSettings.token!,
    displayName: currentUserName,
    currentUserId: currentUserId,
  );
}
