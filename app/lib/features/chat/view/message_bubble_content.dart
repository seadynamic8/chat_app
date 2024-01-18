import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat/view/video_label_message.dart';
import 'package:flutter/material.dart';

class MessageBubbleContent extends StatelessWidget {
  const MessageBubbleContent({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  final Message message;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: switch (message.type) {
        MessageType.video =>
          VideoLabelMessage(message: message, isCurrentUser: isCurrentUser),

        // MESSAGE CONTENT
        _ => Text(
            message.content!,
            style: TextStyle(
              height: 1.3,
              color: isCurrentUser
                  ? theme.colorScheme.onBackground.withAlpha(200)
                  : theme.colorScheme.onSecondary,
            ),
          ),
      },
    );
  }
}
