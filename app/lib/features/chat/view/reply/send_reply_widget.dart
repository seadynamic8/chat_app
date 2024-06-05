import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat/view/reply/reply_message_widget.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SendReplyWidget extends ConsumerWidget {
  const SendReplyWidget({super.key, required this.replyMessage});

  final Message replyMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final usernameValue = ref.watch(
      profileStreamProvider(replyMessage.profileId!).select(
        (value) => value.whenData((profile) => profile?.username),
      ),
    );

    return AsyncValueWidget(
      value: usernameValue,
      data: (username) => Container(
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.only(top: 3, bottom: 3, left: 15, right: 20),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                '${'Replying to: '.i18n} $username',
                style: theme.textTheme.bodySmall!.copyWith(
                  color: theme.hintColor,
                  fontSize: 10,
                ),
              ),
            ),
            ReplyMessageWidget(
                replyMessage: replyMessage, canCancelReply: true),
          ],
        ),
      ),
      showLoading: false,
    );
  }
}
