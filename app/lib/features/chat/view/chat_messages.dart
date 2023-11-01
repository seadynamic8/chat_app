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
  @override
  Widget build(BuildContext context) {
    final messagesValue =
        ref.watch(chatMessagesControllerProvider(widget.roomId));

    return Column(
      children: [
        Expanded(
          child: AsyncValueWidget(
            value: messagesValue,
            data: (messages) {
              return ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];

                  return MessageBubble(
                    message: message,
                    profile: widget.profiles[message.profileId],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
