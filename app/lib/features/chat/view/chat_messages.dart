import 'package:chat_app/common/paginated_list_view.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
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
    required this.profiles,
    required this.scrollController,
  });

  final String roomId;
  final Map<String, Profile> profiles;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final stateValue =
        ref.watch(chatMessagesControllerProvider(roomId, profiles));

    final getNextPage = ref
        .read(chatMessagesControllerProvider(roomId, profiles).notifier)
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

                    return message.type == 'newday'
                        ? StatusMessage(content: message.content)
                        : MessageBubble(
                            key: ValueKey(message.id),
                            message: message,
                            profile: profiles[message.profileId]!,
                          );
                  },
                ),
              );
      },
    );
  }
}
