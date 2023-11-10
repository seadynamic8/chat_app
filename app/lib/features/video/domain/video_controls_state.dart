import 'package:chat_app/features/video/domain/device_info.dart';

class VideoControlsState {
  VideoControlsState({
    this.micEnabled = true,
    this.camEnabled = true,
    required this.allCameras,
  });

  bool micEnabled;
  bool camEnabled;
  final List<DeviceInfo> allCameras;

  VideoControlsState copyWith({
    bool? micEnabled,
    bool? camEnabled,
    List<DeviceInfo>? allCameras,
  }) {
    return VideoControlsState(
      micEnabled: micEnabled ?? this.micEnabled,
      camEnabled: camEnabled ?? this.camEnabled,
      allCameras: allCameras ?? this.allCameras,
    );
  }

  @override
  String toString() =>
      'VideoControlsState(localParticipant: $micEnabled, camEnabled: $camEnabled, allCameras: $allCameras)';

  @override
  bool operator ==(covariant VideoControlsState other) {
    if (identical(this, other)) return true;

    return other.micEnabled == micEnabled &&
        other.camEnabled == camEnabled &&
        other.allCameras == allCameras;
  }

  @override
  int get hashCode =>
      micEnabled.hashCode ^ camEnabled.hashCode ^ allCameras.hashCode;
}
