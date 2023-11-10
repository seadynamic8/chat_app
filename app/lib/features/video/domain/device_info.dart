import 'package:videosdk/videosdk.dart';

// Wrapper class around 'MediaDeviceInfo' class
class DeviceInfo {
  DeviceInfo({required this.mdi});

  final MediaDeviceInfo mdi;

  String get deviceId => mdi.deviceId;

  @override
  String toString() =>
      'DeviceInfo(mdi: Mdi(deviceId: ${mdi.deviceId}, kind: ${mdi.kind}, label: ${mdi.label}))';

  @override
  bool operator ==(covariant DeviceInfo other) {
    if (identical(this, other)) return true;

    return other.mdi.deviceId == mdi.deviceId;
  }

  @override
  int get hashCode => mdi.hashCode ^ mdi.hashCode;
}
