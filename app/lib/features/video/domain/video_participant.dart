import 'package:chat_app/features/video/domain/video_stream.dart';
import 'package:videosdk/videosdk.dart';

/// Wrapper class around VideoSDK 'Participant' class
class VideoParticipant {
  VideoParticipant({required this.participant});

  final Participant participant;

  String get id => participant.id;
  String get displayName => participant.displayName;
  bool get isLocal => participant.isLocal;
  Map<String, dynamic>? get metaData => participant.metaData;

  Map<String, VideoStream> get streams {
    return participant.streams
        .map((id, stream) => MapEntry(id, VideoStream(stream: stream)));
  }

  void onStreamEnabled(void Function(VideoStream videoStream) callback) {
    participant.on(Events.streamEnabled, (Stream stream) {
      callback(VideoStream(stream: stream));
    });
  }

  void onStreamDisabled(void Function(VideoStream videoStream) callback) {
    participant.on(Events.streamDisabled, (Stream stream) {
      callback(VideoStream(stream: stream));
    });
  }
}
