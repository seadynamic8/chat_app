import 'package:videosdk/videosdk.dart';

/// Wrapper class around VideoSDK 'Stream' class
class VideoStream {
  VideoStream({required this.stream});

  final Stream stream;

  String? get kind => stream.kind;
  RTCVideoRenderer? get renderer => stream.renderer;
}
