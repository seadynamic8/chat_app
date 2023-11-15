import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/video/domain/video_participant.dart';

class VideoRoomState {
  VideoRoomState({
    required this.localParticipant,
    required this.remoteParticipants,
    this.remoteJoined = false,
    required this.profiles,
  });

  final VideoParticipant localParticipant;
  final Map<String, VideoParticipant> remoteParticipants;
  final bool remoteJoined;
  final Map<String, Profile> profiles;

  VideoRoomState copyWith({
    VideoParticipant? localParticipant,
    Map<String, VideoParticipant>? remoteParticipants,
    bool? remoteJoined,
    Map<String, Profile>? profiles,
  }) {
    return VideoRoomState(
      localParticipant: localParticipant ?? this.localParticipant,
      remoteParticipants: remoteParticipants ?? this.remoteParticipants,
      remoteJoined: remoteJoined ?? this.remoteJoined,
      profiles: profiles ?? this.profiles,
    );
  }

  @override
  String toString() =>
      'VideoRoomState(localParticipant: $localParticipant, remoteParticipants: $remoteParticipants, remoteParticipants: $remoteParticipants, profiles: $profiles)';

  @override
  bool operator ==(covariant VideoRoomState other) {
    if (identical(this, other)) return true;

    return other.localParticipant == localParticipant &&
        other.remoteParticipants == remoteParticipants &&
        other.remoteJoined == remoteJoined &&
        other.profiles == profiles;
  }

  @override
  int get hashCode =>
      localParticipant.hashCode ^
      remoteParticipants.hashCode ^
      remoteJoined.hashCode ^
      profiles.hashCode;
}
