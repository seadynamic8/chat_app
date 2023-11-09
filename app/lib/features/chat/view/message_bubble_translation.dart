import 'package:flutter/material.dart';

class MessageBubbleTranslation extends StatelessWidget {
  const MessageBubbleTranslation({
    super.key,
    required this.translation,
    required this.isCurrentUser,
  });

  final String translation;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser
            ? Colors.grey.withAlpha(200)
            : theme.colorScheme.background.withAlpha(100),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.zero,
          topRight: Radius.zero,
          bottomLeft: Radius.circular(9),
          bottomRight: Radius.circular(9),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      child: Text(
        translation,
        style: TextStyle(
          height: 1.3,
          color: isCurrentUser
              ? Colors.black87
              : theme.colorScheme.onBackground.withAlpha(200),
        ),
        softWrap: true,
      ),
    );
  }
}
