import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart';

class VideoTile extends StatefulWidget {
  const VideoTile({super.key, required this.participant});

  final Participant participant;

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  Stream? videoStream;

  @override
  Widget build(BuildContext context) {
    return videoStream != null
        ? RTCVideoView(
            videoStream!.renderer as RTCVideoRenderer,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
