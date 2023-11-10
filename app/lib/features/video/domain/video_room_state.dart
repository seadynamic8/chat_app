import 'package:chat_app/features/video/domain/video_participant.dart';

class VideoRoomState {
  VideoRoomState({
    required this.localParticipant,
    required this.remoteParticipants,
  });

  final VideoParticipant localParticipant;
  final Map<String, VideoParticipant> remoteParticipants;

  VideoRoomState copyWith({
    VideoParticipant? localParticipant,
    Map<String, VideoParticipant>? remoteParticipants,
  }) {
    return VideoRoomState(
      localParticipant: localParticipant ?? this.localParticipant,
      remoteParticipants: remoteParticipants ?? this.remoteParticipants,
    );
  }

  @override
  String toString() =>
      'VideoRoomState(localParticipant: $localParticipant, remoteParticipants: $remoteParticipants)';

  @override
  bool operator ==(covariant VideoRoomState other) {
    if (identical(this, other)) return true;

    return other.localParticipant == localParticipant &&
        other.remoteParticipants == remoteParticipants;
  }

  @override
  int get hashCode => localParticipant.hashCode ^ remoteParticipants.hashCode;
}
