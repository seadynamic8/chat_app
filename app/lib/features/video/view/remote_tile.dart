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
                Positioned(
                  top: 19,
                  left: 60,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(remoteParticipant!.displayName),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
