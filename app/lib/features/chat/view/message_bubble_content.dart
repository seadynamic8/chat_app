import 'package:chat_app/i18n/localizations.dart';
import 'package:flutter/material.dart';

class MessageBubbleContent extends StatelessWidget {
  const MessageBubbleContent({
    super.key,
    required this.type,
    required this.content,
    required this.isCurrentUser,
  });

  final String type;
  final String content;
  final bool isCurrentUser;

  bool get missed => content == 'missed';

  String get videoLabel {
    if (missed) {
      return 'Missed video call'.i18n;
    }
    return 'Video call '.i18n + content;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: type == 'video'
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: missed ? Colors.red : Colors.grey,
                  ),
                  child: Icon(
                    missed
                        ? Icons.missed_video_call_rounded
                        : Icons.videocam_rounded,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  videoLabel,
                  style: theme.textTheme.labelLarge,
                  overflow: TextOverflow.fade,
                )
              ],
            )
          : Text(
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
