import 'package:chat_app/features/video/view/video_tile.dart';
import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart';

class LocalTile extends StatelessWidget {
  const LocalTile(
      {super.key, required this.isLoading, required this.localParticipant});

  final bool isLoading;
  final Participant localParticipant;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      right: 20,
      child: SizedBox(
        height: 170,
        width: 120,
        child: isLoading
            ? const Center(child: Text('loading local participant'))
            : VideoTile(participant: localParticipant),
      ),
    );
  }
}
