import 'package:chat_app/features/home/application/current_user_id_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat/view/reply/reply_message_widget.dart';
import 'package:flutter/material.dart';

class ReceiveReplyWidget extends ConsumerWidget {
  const ReceiveReplyWidget({
    super.key,
    required this.replyMessage,
    required this.isCurrentUser,
  });

  final Message replyMessage;
  final bool isCurrentUser;

  String? get replyMessageId => replyMessage.profileId;

  bool _isReplySelf(bool isReplyCurrentUser) {
    return (isCurrentUser && isReplyCurrentUser) ||
        (!isCurrentUser && !isReplyCurrentUser);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentUserId = ref.read(currentUserIdProvider);

    final isReplyCurrentUser = replyMessageId == currentUserId;

    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: _isReplySelf(isReplyCurrentUser)
              ? Colors.grey.withOpacity(0.2)
              : isCurrentUser
                  ? theme.colorScheme.primary.withOpacity(0.2)
                  : theme.colorScheme.secondary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ReplyMessageWidget(replyMessage: replyMessage),
      ),
    );
  }
}
