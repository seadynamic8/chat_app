import 'package:chat_app/common/paginated_list_view.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/data/joined_room_notifier.dart';
import 'package:chat_app/features/chat/data/swiped_message_provider.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat/view/chat_messages_controller.dart';
import 'package:chat_app/features/chat/view/message_tile.dart';
import 'package:chat_app/features/chat/view/status_message.dart';
import 'package:chat_app/features/home/application/current_user_id_provider.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swipe_to/swipe_to.dart';

class ChatMessages extends ConsumerWidget {
  const ChatMessages({
    super.key,
    required this.roomId,
    required this.otherProfileId,
    required this.scrollController,
    required this.msgFieldFocusNode,
  });

  final String roomId;
  final String otherProfileId;
  final ScrollController scrollController;
  final FocusNode msgFieldFocusNode;

  bool isCurrentUser(WidgetRef ref, String profileId) {
    return profileId == ref.watch(currentUserIdProvider)!;
  }

  String getblockAction(WidgetRef ref, Message message) {
    return message.blockAction(
        isCurrentUser: isCurrentUser(ref, message.profileId!));
  }

  void onSwipedMessage(WidgetRef ref, Message swipedMessage) {
    ref.read(swipedMessageProvider.notifier).set(swipedMessage);
    msgFieldFocusNode.requestFocus();
  }

  void listenForNewMessage(WidgetRef ref) {
    ref.listen<AsyncValue<Message>>(
      newMessagesStreamProvider(roomId),
      (_, state) => state.whenData((newMessage) async {
        await ref
            .read(chatMessagesControllerProvider(roomId).notifier)
            .handleNewMessage(newMessage);
        _scrollUp();
      }),
    );
  }

  void _scrollUp() {
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final joinedValue = ref.watch(joinedRoomNotifierProvider(roomId));
    final stateValue = ref.watch(chatMessagesControllerProvider(roomId));

    final getNextPage = ref
        .read(chatMessagesControllerProvider(roomId).notifier)
        .getNextPageOfMessages;

    listenForNewMessage(ref);

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
                      MessageType.newday => StatusMessage(
                          key: UniqueKey(), content: message.content!),
                      MessageType.block => StatusMessage(
                          key: UniqueKey(),
                          content: getblockAction(ref, message),
                        ),
                      _ => SwipeTo(
                          key: ValueKey(message.id), // needs to be unique key
                          onRightSwipe: isCurrentUser(ref, message.profileId!)
                              ? null
                              : (_) => onSwipedMessage(ref, message),
                          onLeftSwipe: isCurrentUser(ref, message.profileId!)
                              ? (_) => onSwipedMessage(ref, message)
                              : null,
                          child: MessageTile(
                            key: ValueKey(message.id),
                            message: message,
                            isCurrentUser:
                                isCurrentUser(ref, message.profileId!),
                          ),
                        ),
                    };
                  },
                ),
              );
      },
      beforeSlivers: joinedValue.maybeWhen(
        data: (joined) => joined == false
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
            : const SliverToBoxAdapter(),
        orElse: () => const SliverToBoxAdapter(),
      ),
    );
  }
}
