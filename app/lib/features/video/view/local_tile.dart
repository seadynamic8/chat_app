import 'package:chat_app/features/video/domain/video_participant.dart';
import 'package:chat_app/features/video/view/video_tile.dart';
import 'package:flutter/material.dart';

class LocalTile extends StatelessWidget {
  const LocalTile(
      {super.key, required this.localParticipant, required this.height});

  final VideoParticipant localParticipant;
  final double height;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);

    return SizedBox(
      height: height,
      width: mediaQuery.width * 0.30,
      child: VideoTile(participant: localParticipant),
    );
  }
}
