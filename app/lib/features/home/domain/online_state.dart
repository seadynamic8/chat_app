import 'package:flutter/material.dart';

enum OnlineStatus {
  online(color: Colors.green),
  busy(color: Colors.red),
  offline(color: Colors.grey);

  const OnlineStatus({required this.color});

  final MaterialColor color;
}

class OnlineState {
  OnlineState({
    required this.profileId,
    this.username,
    required this.status,
    required this.enteredAt,
  });

  final String profileId;
  final String? username;
  final OnlineStatus status;
  final DateTime enteredAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profileId': profileId,
      'username': username,
      'status': status.name,
      'enteredAt': enteredAt.toIso8601String(),
    };
  }

  factory OnlineState.fromMap(Map<String, dynamic> map) {
    return OnlineState(
      profileId: map['profileId'] as String,
      username: map['username'] != null ? map['username'] as String : null,
      status: OnlineStatus.values.byName(map['status']),
      enteredAt: DateTime.parse(map['enteredAt'] as String),
    );
  }

  @override
  bool operator ==(covariant OnlineState other) {
    if (identical(this, other)) return true;

    return other.profileId == profileId &&
        other.username == username &&
        other.status == status &&
        other.enteredAt == enteredAt;
  }

  @override
  int get hashCode =>
      profileId.hashCode ^
      username.hashCode ^
      status.hashCode ^
      enteredAt.hashCode;

  @override
  String toString() =>
      'OnlineState(profileId: $profileId, username: $username, status: ${status.name}, enteredAt: $enteredAt)';
}
