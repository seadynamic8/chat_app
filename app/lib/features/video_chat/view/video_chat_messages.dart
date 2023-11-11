import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/video_chat/view/video_chat_controller.dart';
import 'package:chat_app/features/video_chat/view/video_chat_message_bubble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class VideoChatMessages extends ConsumerWidget {
  const VideoChatMessages({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesValue = ref.watch(videoChatControllerProvider);
    final mediaQuery = MediaQuery.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: mediaQuery.size.width * 0.7,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red), // TODO: For debugging
      ),
      child: AsyncValueWidget(
        value: messagesValue,
        data: (messages) => ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return VideoChatMessageBubble(message: message);
          },
        ),
      ),
    );
  }
}
