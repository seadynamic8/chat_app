import 'package:chat_app/features/video/domain/video_participant.dart';

class VideoRoomState {
  VideoRoomState({
    required this.localParticipant,
    required this.remoteParticipants,
    this.remoteJoined = false,
  });

  final VideoParticipant localParticipant;
  final Map<String, VideoParticipant> remoteParticipants;
  final bool remoteJoined;

  VideoRoomState copyWith({
    VideoParticipant? localParticipant,
    Map<String, VideoParticipant>? remoteParticipants,
    bool? remoteJoined,
  }) {
    return VideoRoomState(
      localParticipant: localParticipant ?? this.localParticipant,
      remoteParticipants: remoteParticipants ?? this.remoteParticipants,
      remoteJoined: remoteJoined ?? this.remoteJoined,
    );
  }

  @override
  String toString() =>
      'VideoRoomState(localParticipant: $localParticipant, remoteParticipants: $remoteParticipants, remoteParticipants: $remoteParticipants)';

  @override
  bool operator ==(covariant VideoRoomState other) {
    if (identical(this, other)) return true;

    return other.localParticipant == localParticipant &&
        other.remoteParticipants == remoteParticipants &&
        other.remoteJoined == remoteJoined;
  }

  @override
  int get hashCode =>
      localParticipant.hashCode ^
      remoteParticipants.hashCode ^
      remoteJoined.hashCode;
}
