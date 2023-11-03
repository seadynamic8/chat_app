import 'package:chat_app/features/video/view/video_tile.dart';
import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart';

class RemoteTile extends StatelessWidget {
  const RemoteTile(
      {super.key, required this.isLoading, required this.remoteParticipants});

  final bool isLoading;
  final List<Participant> remoteParticipants;

  @override
  Widget build(BuildContext context) {
    return isLoading || remoteParticipants.isEmpty
        ? Container()
        : Stack(
            children: [
              VideoTile(participant: remoteParticipants.first),
              Positioned(
                top: 70,
                left: 60,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(remoteParticipants.first.displayName),
                  ),
                ),
              ),
            ],
          );
  }
}
