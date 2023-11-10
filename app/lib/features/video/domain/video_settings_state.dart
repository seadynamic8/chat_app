class VideoSettingsState {
  VideoSettingsState({this.token, this.roomId});

  final String? token;
  final String? roomId;

  VideoSettingsState copyWith({
    String? token,
    String? roomId,
  }) {
    return VideoSettingsState(
      token: token ?? this.token,
      roomId: roomId ?? this.roomId,
    );
  }

  @override
  bool operator ==(covariant VideoSettingsState other) {
    if (identical(this, other)) return true;

    return other.token == token && other.roomId == roomId;
  }

  @override
  int get hashCode => token.hashCode ^ roomId.hashCode;

  @override
  String toString() => 'VideoSettingsState(token: $token, roomId: $roomId)';
}
