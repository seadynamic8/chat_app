import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat/view/chat_messages_controller.dart';
import 'package:chat_app/features/chat/view/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ChatMessages extends ConsumerWidget {
  const ChatMessages({super.key, required this.roomId, required this.profiles});

  final String roomId;
  final Map<String, Profile> profiles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pagingController = ref.watch(chatMessagesControllerProvider(roomId));

    return Column(
      children: [
        Expanded(
          child: PagedListView<int, Message>(
            pagingController: pagingController,
            reverse: true,
            shrinkWrap: true,
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) {
                final message = item;

                return MessageBubble(
                  message: message,
                  profile: profiles[message.profileId],
                );
              },
              noItemsFoundIndicatorBuilder: (context) => SizedBox(
                height: 100,
                child: Center(
                  child: Text(
                    'Send your first message =)',
                    style: theme.textTheme.labelLarge!.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
