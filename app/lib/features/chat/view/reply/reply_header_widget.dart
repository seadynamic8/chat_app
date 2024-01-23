import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReplyHeaderWidget extends ConsumerWidget {
  const ReplyHeaderWidget({
    super.key,
    required this.replyMessageId,
    required this.isCurrentUser,
  });

  final String replyMessageId;
  final bool isCurrentUser;

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentUserId = ref.read(currentUserIdProvider);

    final isReplyCurrentUser = replyMessageId == currentUserId;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        _replyToText(isReplyCurrentUser),
        style: theme.textTheme.bodySmall!.copyWith(
          color: theme.hintColor,
          fontSize: 10,
        ),
      ),
    );
  }
}
