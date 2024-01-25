import 'package:chat_app/features/video/domain/video_participant.dart';

class VideoRoomState {
  VideoRoomState({
    required this.localParticipant,
    required this.remoteParticipants,
    this.remoteJoined = false,
    this.isAppPaused = false,
  });

  final VideoParticipant localParticipant;
  final Map<String, VideoParticipant> remoteParticipants;
  final bool remoteJoined;
  final bool isAppPaused;

  VideoRoomState copyWith({
    VideoParticipant? localParticipant,
    Map<String, VideoParticipant>? remoteParticipants,
    bool? remoteJoined,
    bool? isAppPaused,
  }) {
    return VideoRoomState(
      localParticipant: localParticipant ?? this.localParticipant,
      remoteParticipants: remoteParticipants ?? this.remoteParticipants,
      remoteJoined: remoteJoined ?? this.remoteJoined,
      isAppPaused: isAppPaused ?? this.isAppPaused,
    );
  }

  @override
  String toString() =>
      'VideoRoomState(localParticipant: $localParticipant, remoteParticipants: $remoteParticipants, remoteParticipants: $remoteParticipants, remoteJoined: $remoteJoined, isAppPaused: $isAppPaused)';

  @override
  bool operator ==(covariant VideoRoomState other) {
    if (identical(this, other)) return true;

    return other.localParticipant == localParticipant &&
        other.remoteParticipants == remoteParticipants &&
        other.remoteJoined == remoteJoined &&
        other.isAppPaused == remoteJoined;
  }

  @override
  int get hashCode =>
      localParticipant.hashCode ^
      remoteParticipants.hashCode ^
      remoteJoined.hashCode ^
      isAppPaused.hashCode;
}
