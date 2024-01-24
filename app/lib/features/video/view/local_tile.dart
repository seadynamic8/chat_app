import 'package:chat_app/features/video/domain/video_participant.dart';
import 'package:chat_app/features/video/view/video_tile.dart';
import 'package:flutter/material.dart';

class LocalTile extends StatelessWidget {
  const LocalTile({
    super.key,
    required this.localParticipant,
    required this.height,
    required this.width,
  });

  final VideoParticipant localParticipant;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: VideoTile(participant: localParticipant),
    );
  }
}
