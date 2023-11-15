import 'package:chat_app/features/video/domain/video_participant.dart';
import 'package:chat_app/features/video/view/video_tile.dart';
import 'package:flutter/material.dart';

class RemoteTile extends StatelessWidget {
  const RemoteTile(
      {super.key, required this.isLoading, required this.remoteParticipant});

  final bool isLoading;
  final VideoParticipant? remoteParticipant;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                VideoTile(participant: remoteParticipant!),
              ],
            ),
    );
  }
}
