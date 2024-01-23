import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat/data/swiped_message_provider.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat/view/reply/reply_message_translation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ReplyMessageWidget extends ConsumerWidget {
  const ReplyMessageWidget({
    super.key,
    required this.replyMessage,
    this.canCancelReply = false,
  });

  final Message replyMessage;
  final bool canCancelReply;

  void _cancelReply(WidgetRef ref) {
    ref.read(swipedMessageProvider.notifier).cancel();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isCurrentUser =
        replyMessage.profileId == ref.watch(currentUserIdProvider)!;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 2, color: theme.hintColor),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    replyMessage.content!,
                    style: theme.textTheme.bodySmall!.copyWith(
                      fontSize: 10,
                      color: theme.colorScheme.onBackground.withOpacity(0.8),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
                if (replyMessage.translation != null && !isCurrentUser)
                  ReplyMessageTranslation(
                    translation: replyMessage.translation!,
                    isCurrentUser: isCurrentUser,
                  )
              ],
            ),
          ),
          if (canCancelReply)
            InkWell(
              onTap: () => _cancelReply(ref),
              child: const Padding(
                padding: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 8),
                child: Icon(
                  Icons.close,
                  size: 16,
                ),
              ),
            )
        ],
      ),
    );
  }
}
