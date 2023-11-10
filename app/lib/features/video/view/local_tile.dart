import 'package:chat_app/features/video/domain/video_participant.dart';
import 'package:chat_app/features/video/view/video_tile.dart';
import 'package:flutter/material.dart';

class LocalTile extends StatelessWidget {
  const LocalTile({super.key, required this.localParticipant});

  final VideoParticipant localParticipant;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      right: 20,
      child: SizedBox(
        height: 170,
        width: 120,
        child: VideoTile(participant: localParticipant),
      ),
    );
  }
}
