enum IncomingCallType {
  waiting,
  // Callee receive
  newCall,
  cancelCall,
  // Caller receive
  acceptCall,
  rejectCall,
}

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
