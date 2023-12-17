enum CallAvailabilityStatus { unavailable, blocked, noCoins, canCall }

class CallAvailabilityState {
  CallAvailabilityState({required this.status, required this.data});

  final CallAvailabilityStatus status;
  final dynamic data;

  @override
  String toString() => 'CallAvailabilityState(status: $status, data: $data)';
}
