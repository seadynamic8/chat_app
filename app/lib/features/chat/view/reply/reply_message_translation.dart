import 'package:flutter/material.dart';

class ReplyMessageTranslation extends StatelessWidget {
  const ReplyMessageTranslation({
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
        // borderRadius: BorderRadius.circular(9),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      child: Text(
        translation,
        style: theme.textTheme.bodySmall!.copyWith(
          height: 1.3,
          fontSize: 10,
          color: isCurrentUser
              ? Colors.black87
              : theme.colorScheme.onSurface.withAlpha(200),
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
    );
  }
}
