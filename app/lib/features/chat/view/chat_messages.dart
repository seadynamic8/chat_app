import 'package:chat_app/common/paginated_list_view.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
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
    required this.roomId,
    required this.otherProfileId,
    required this.joined,
    required this.scrollController,
  });

  final String roomId;
  final String otherProfileId;
  final bool joined;
  final ScrollController scrollController;

  bool isCurrentUser(WidgetRef ref, String profileId) {
    return profileId == ref.watch(currentUserIdProvider)!;
  }

  String getblockAction(WidgetRef ref, Message message) {
    return message.blockAction(
        isCurrentUser: isCurrentUser(ref, message.profileId!));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final stateValue = ref.watch(chatMessagesControllerProvider(roomId));

    final getNextPage = ref
        .read(chatMessagesControllerProvider(roomId).notifier)
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
                        StatusMessage(content: message.content!),
                      MessageType.block =>
                        StatusMessage(content: getblockAction(ref, message)),
                      _ => MessageBubble(
                          key: ValueKey(message.id),
                          message: message,
                          isCurrentUser: isCurrentUser(ref, message.profileId!),
                        ),
                    };
                  },
                ),
              );
      },
      beforeSlivers: joined == false
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
