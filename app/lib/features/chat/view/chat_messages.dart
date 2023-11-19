import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/view/chat_messages_controller.dart';
import 'package:chat_app/features/chat/view/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessages extends ConsumerStatefulWidget {
  const ChatMessages({super.key, required this.roomId, required this.profiles});

  final String roomId;
  final Map<String, Profile> profiles;

  @override
  ConsumerState<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends ConsumerState<ChatMessages> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_fetchNewMessages);
  }

  void _fetchNewMessages() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Set it to update when only 30% of the screen left.
    final delta = MediaQuery.of(context).size.height * 0.30;

    if (maxScroll - currentScroll <= delta) {
      ref
          .read(chatMessagesControllerProvider(widget.roomId, widget.profiles)
              .notifier)
          .getNextPageOfMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stateValue = ref
        .watch(chatMessagesControllerProvider(widget.roomId, widget.profiles));

    return AsyncValueWidget(
      value: stateValue,
      data: (state) {
        final messages = state.messages;

        return messages.isEmpty
            ? Center(
                child: Text(
                  'Send your first message =)',
                  style: theme.textTheme.labelLarge!.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              )
            : ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];

                  return MessageBubble(
                    message: message,
                    profile: widget.profiles[message.profileId]!,
                  );
                },
              );
      },
    );
  }
}
