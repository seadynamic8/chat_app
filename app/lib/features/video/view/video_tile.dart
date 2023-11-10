import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/video/domain/video_participant.dart';
import 'package:chat_app/features/video/view/video_tile_controller.dart';
import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart';

class VideoTile extends ConsumerWidget {
  const VideoTile({super.key, required this.participant});

  final VideoParticipant participant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoStream = ref.watch(videoTileControllerProvider(participant));

    return videoStream != null && videoStream.renderer != null
        ? RTCVideoView(
            videoStream.renderer!,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
