import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewestMessageContent extends ConsumerWidget {
  const NewestMessageContent({super.key, required this.newestMessage});

  final Message newestMessage;

  String _filterNewestMessage(WidgetRef ref, Message newestMessage) {
    final isCurrentUser = _messageIsCurrentUser(ref, newestMessage);

    switch (newestMessage.type) {
      case MessageType.video:
        return '[ ${newestMessage.videoLabel(isCurrentUser)} ]';
      case MessageType.block:
        return '[ ${newestMessage.blockAction(isCurrentUser: isCurrentUser)} ]';
      default:
        if (newestMessage.translation != null && !isCurrentUser) {
          return newestMessage.translation!;
        }
        return newestMessage.content!;
    }
  }

  bool _messageIsCurrentUser(WidgetRef ref, Message message) {
    final currentUserId = ref.watch(currentUserIdProvider)!;
    return message.profileId == currentUserId;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      _filterNewestMessage(ref, newestMessage),
      style: Theme.of(context)
          .textTheme
          .labelMedium!
          .copyWith(color: Theme.of(context).hintColor),
      overflow: TextOverflow.fade,
      softWrap: false,
      maxLines: 1,
    );
  }
}
