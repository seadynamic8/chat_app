enum IncomingCallType { newCall, cancelCall, waiting }

class IncomingCallState {
  IncomingCallState({
    this.otherUsername,
    this.videoRoomId,
    this.callType = IncomingCallType.waiting,
  });

  final String? otherUsername;
  final String? videoRoomId;
  IncomingCallType callType;
}
