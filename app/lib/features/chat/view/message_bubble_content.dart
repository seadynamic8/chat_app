import 'package:flutter/material.dart';

class MessageBubbleContent extends StatelessWidget {
  const MessageBubbleContent({
    super.key,
    required this.content,
    required this.isCurrentUser,
  });

  final String content;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: Text(
        content,
        style: TextStyle(
          height: 1.3,
          color: isCurrentUser
              ? theme.colorScheme.onBackground.withAlpha(200)
              : theme.colorScheme.onSecondary,
        ),
        softWrap: true,
      ),
    );
  }
}
