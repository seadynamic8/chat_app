// ignore_for_file: public_member_api_docs, sort_constructors_first
enum OnlineStatus { online, busy }

class OnlineState {
  OnlineState({
    required this.profileId,
    required this.status,
    required this.enteredAt,
  });

  final String profileId;
  final OnlineStatus status;
  final DateTime enteredAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profileId': profileId,
      'status': status.name,
      'enteredAt': enteredAt.millisecondsSinceEpoch,
    };
  }

  factory OnlineState.fromMap(Map<String, dynamic> map) {
    return OnlineState(
      profileId: map['profileId'] as String,
      status: OnlineStatus.values.byName(map['status']),
      enteredAt: DateTime.parse(map['enteredAt'] as String),
    );
  }

  @override
  bool operator ==(covariant OnlineState other) {
    if (identical(this, other)) return true;

    return other.profileId == profileId &&
        other.status == status &&
        other.enteredAt == enteredAt;
  }

  @override
  int get hashCode => profileId.hashCode ^ status.hashCode ^ enteredAt.hashCode;

  @override
  String toString() =>
      'OnlineState(profileId: $profileId, status: $status, enteredAt: $enteredAt)';
}
