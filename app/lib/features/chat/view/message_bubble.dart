import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat/view/message_bubble_content.dart';
import 'package:chat_app/features/chat/view/message_bubble_translation.dart';
import 'package:chat_app/features/chat/view/reply/receive_reply_widget.dart';
import 'package:chat_app/features/chat/view/reply/reply_header_widget.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.60),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (isReplying)
            ReplyHeaderWidget(
              replyMessageId: message.replyMessage!.profileId!,
              isCurrentUser: isCurrentUser,
            ),
          if (isReplying)
            ReceiveReplyWidget(
              replyMessage: message.replyMessage!,
              isCurrentUser: isCurrentUser,
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
