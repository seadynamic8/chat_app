// ignore_for_file: public_member_api_docs, sort_constructors_first
enum CallRequestType {
  waiting,
  // Callee receive
  newCall,
  cancelCall,
  // Caller receive
  acceptCall,
  rejectCall,
  // Call end
  endCall
}

class CallRequestState {
  CallRequestState({
    this.otherUserId,
    this.otherUsername,
    this.videoRoomId,
    this.callType = CallRequestType.waiting,
  });

  final String? otherUserId;
  final String? otherUsername;
  final String? videoRoomId;
  CallRequestType callType;

  @override
  String toString() =>
      'CallRequestState(otherUserId: $otherUserId, otherUsername: $otherUsername, videoRoomId: $videoRoomId, callType: ${callType.name})';

  CallRequestState copyWith({
    String? otherUserId,
    String? otherUsername,
    String? videoRoomId,
    dynamic callType,
  }) {
    return CallRequestState(
      otherUserId: otherUserId ?? this.otherUserId,
      otherUsername: otherUsername ?? this.otherUsername,
      videoRoomId: videoRoomId ?? this.videoRoomId,
      callType: callType ?? CallRequestType.waiting,
    );
  }

  @override
  bool operator ==(covariant CallRequestState other) {
    if (identical(this, other)) return true;

    return other.otherUserId == otherUserId &&
        other.otherUsername == otherUsername &&
        other.videoRoomId == videoRoomId &&
        other.callType == other.callType;
  }

  @override
  int get hashCode =>
      otherUserId.hashCode ^
      otherUsername.hashCode ^
      videoRoomId.hashCode ^
      callType.hashCode;
}
