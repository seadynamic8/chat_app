import 'package:chat_app/features/chat/domain/message.dart';
import 'package:flutter/material.dart';

class VideoLabelMessage extends StatelessWidget {
  const VideoLabelMessage({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  final Message message;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: message.missed(isCurrentUser) ? Colors.red : Colors.grey,
          ),
          child: Icon(
            message.missed(isCurrentUser)
                ? Icons.missed_video_call_rounded
                : Icons.videocam_rounded,
            size: 20,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          message.videoLabel(isCurrentUser),
          style: theme.textTheme.labelLarge,
          overflow: TextOverflow.fade,
        )
      ],
    );
  }
}
