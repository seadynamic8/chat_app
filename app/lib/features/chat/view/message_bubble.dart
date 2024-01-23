import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat/view/message_bubble_content.dart';
import 'package:chat_app/features/chat/view/message_bubble_translation.dart';
import 'package:chat_app/features/chat/view/reply_message_widget.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageBubble extends ConsumerWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  final Message message;
  final bool isCurrentUser;

  bool get isReplying => message.replyMessage != null;
  String? get replyId => message.replyMessage?.profileId;

  String _replyToText(bool isReplyCurrentUser) {
    if (isCurrentUser && isReplyCurrentUser) {
      return 'You replied to yourself'.i18n;
    }
    if (isCurrentUser && !isReplyCurrentUser) {
      return 'You replied'.i18n;
    }
    if (!isCurrentUser && !isReplyCurrentUser) {
      return 'Replied to themself'.i18n;
    } else {
      return 'Replied to you'.i18n;
    }
  }

  bool _isReplySelf(bool isReplyCurrentUser) {
    return (isCurrentUser && isReplyCurrentUser) ||
        (!isCurrentUser && !isReplyCurrentUser);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentUserId = ref.read(currentUserIdProvider);

    final isReplyCurrentUser = replyId == currentUserId;

    return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.60),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (isReplying)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                _replyToText(isReplyCurrentUser),
                style: theme.textTheme.bodySmall!.copyWith(
                  color: theme.hintColor,
                  fontSize: 10,
                ),
              ),
            ),
          if (isReplying)
            IntrinsicWidth(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: _isReplySelf(isReplyCurrentUser)
                      ? Colors.grey.withOpacity(0.2)
                      : isCurrentUser
                          ? theme.colorScheme.primary.withOpacity(0.2)
                          : theme.colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ReplyMessageWidget(replyMessage: message.replyMessage!),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? Colors.grey[700]
                  : theme.colorScheme.secondary,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft:
                    !isCurrentUser ? Radius.zero : const Radius.circular(12),
                bottomRight:
                    isCurrentUser ? Radius.zero : const Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                MessageBubbleContent(
                  message: message,
                  isCurrentUser: isCurrentUser,
                ),
                if (message.translation != null && !isCurrentUser)
                  MessageBubbleTranslation(
                    translation: message.translation!,
                    isCurrentUser: isCurrentUser,
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
