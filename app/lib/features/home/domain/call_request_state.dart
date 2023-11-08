enum CallRequestType {
  waiting,
  // Callee receive
  newCall,
  cancelCall,
  // Caller receive
  acceptCall,
  rejectCall,
}

class CallRequestState {
  CallRequestState({
    this.otherUsername,
    this.videoRoomId,
    this.callType = CallRequestType.waiting,
  });

  final String? otherUsername;
  final String? videoRoomId;
  CallRequestType callType;
}
