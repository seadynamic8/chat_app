import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/chat_lobby/data/chat_lobby_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter/material.dart';

class ChatTabIcon extends ConsumerWidget {
  const ChatTabIcon({super.key});

  String unReadMessagesCountString(int unReadCount) {
    if (unReadCount > 999) {
      return '999+';
    }
    return unReadCount.toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unReadMessageCountValue =
        ref.watch(unReadMessageCountStreamProvider());

    const regularChatTab = Icon(
      Icons.message,
      key: K.chatsTab,
    );

    return AsyncValueWidget(
      value: unReadMessageCountValue,
      data: (unReadMessageCount) => unReadMessageCount > 0
          ? Badge(
              key: K.chatsBadgeTab,
              label: Text(unReadMessagesCountString(unReadMessageCount)),
              child: const Icon(
                Icons.message,
                key: K.chatsTab,
              ),
            )
          : regularChatTab,
      loading: regularChatTab,
    );
  }
}
