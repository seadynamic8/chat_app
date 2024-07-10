enum CallAvailabilityStatus {
  unavailable,
  blocked,
  noCoins,
  notJoined,
  canCall,
}

class CallAvailabilityState {
  CallAvailabilityState({required this.status, required this.data});

  final CallAvailabilityStatus status;
  final dynamic data;

  @override
  String toString() => 'CallAvailabilityState(status: $status, data: $data)';
}
