import 'package:chat_app/features/video/domain/video_participant.dart';
import 'package:chat_app/features/video/view/video_tile.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:flutter/material.dart';

class RemoteTile extends StatelessWidget {
  const RemoteTile({
    super.key,
    required this.isLoading,
    required this.remoteParticipant,
    this.fakeMode = false,
  });

  final bool isLoading;
  final VideoParticipant? remoteParticipant;
  final bool fakeMode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : fakeMode == true
              ? Image.asset(fakeAvatarImageRemote, fit: BoxFit.cover)
              : Stack(
                  children: [
                    VideoTile(participant: remoteParticipant!),
                  ],
                ),
    );
  }
}
