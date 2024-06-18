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
            : theme.colorScheme.surface.withAlpha(100),
        borderRadius: BorderRadius.only(
          topLeft: Radius.zero,
          topRight: Radius.zero,
          bottomLeft: !isCurrentUser ? Radius.zero : const Radius.circular(9),
          bottomRight: isCurrentUser ? Radius.zero : const Radius.circular(9),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      child: Text(
        translation,
        style: TextStyle(
          height: 1.3,
          color: isCurrentUser
              ? Colors.black87
              : theme.colorScheme.onSurface.withAlpha(200),
        ),
      ),
    );
  }
}
