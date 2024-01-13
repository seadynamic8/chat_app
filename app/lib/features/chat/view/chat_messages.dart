import 'package:chat_app/common/paginated_list_view.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat/domain/chat_room.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat/view/chat_messages_controller.dart';
import 'package:chat_app/features/chat/view/message_bubble.dart';
import 'package:chat_app/features/chat/view/status_message.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessages extends ConsumerWidget {
  const ChatMessages({
    super.key,
    required this.chatRoom,
    required this.scrollController,
  });

  final ChatRoom chatRoom;
  final ScrollController scrollController;

  String getblockAction(WidgetRef ref, Message message) {
    final isCurrentUser =
        message.profileId == ref.watch(currentUserIdProvider)!;
    return message.blockAction(isCurrentUser: isCurrentUser);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final stateValue = ref.watch(chatMessagesControllerProvider(chatRoom));

    final getNextPage = ref
        .read(chatMessagesControllerProvider(chatRoom).notifier)
        .getNextPageOfMessages;

    return PaginatedListView<Message>(
      scrollController: scrollController,
      reverse: true,
      getNextPage: getNextPage,
      itemsLabel: 'messages'.i18n,
      value: stateValue,
      data: (state) {
        final messages = state.items;

        return messages.isEmpty
            ? SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    'Send your first message =)'.i18n,
                    style: theme.textTheme.labelLarge!.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: messages.length,
                  (context, index) {
                    final message = messages[index];

                    return switch (message.type) {
                      MessageType.newday =>
                        StatusMessage(content: message.content),
                      MessageType.block =>
                        StatusMessage(content: getblockAction(ref, message)),
                      _ => MessageBubble(
                          key: ValueKey(message.id),
                          message: message,
                          profile: chatRoom.profiles[message.profileId]!,
                        ),
                    };
                  },
                ),
              );
      },
      beforeSlivers: chatRoom.joined == false
          ? SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                child: Center(
                  child: Text(
                    'When you reply, the other user will be able to contact you.'
                        .i18n,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
