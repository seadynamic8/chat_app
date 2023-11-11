import 'package:chat_app/features/video/domain/video_participant.dart';
import 'package:chat_app/features/video/domain/video_stream.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_tile_controller.g.dart';

@riverpod
class VideoTileController extends _$VideoTileController {
  @override
  VideoStream? build(VideoParticipant videoParticipant) {
    videoParticipant.streams.forEach(_addInitialStream);

    videoParticipant.onStreamEnabled(_streamEnabled);
    videoParticipant.onStreamDisabled(_streamDisabled);
    return null;
  }

  void _addInitialStream(String id, VideoStream videoStream) {
    if (videoStream.kind == 'video') {
      state = videoStream;
    }
  }

  void _streamEnabled(VideoStream videoStream) {
    if (videoStream.kind == 'video') {
      state = videoStream;
    }
  }

  void _streamDisabled(VideoStream videoStream) {
    if (videoStream.kind == 'video') {
      state = null;
    }
  }
}
