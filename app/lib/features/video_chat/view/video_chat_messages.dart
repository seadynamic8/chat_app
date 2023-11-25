import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/video_chat/view/video_chat_controller.dart';
import 'package:chat_app/features/video_chat/view/video_chat_message_bubble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class VideoChatMessages extends ConsumerWidget {
  const VideoChatMessages({super.key, required this.otherProfileId});

  final String otherProfileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateValue = ref.watch(videoChatControllerProvider(otherProfileId));
    final mediaQuerySize = MediaQuery.sizeOf(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: mediaQuerySize.width * 0.7,
      child: AsyncValueWidget(
        value: stateValue,
        data: (state) {
          final messages = state.messages;

          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];

              return VideoChatMessageBubble(
                key: ValueKey(message.id),
                message: message,
                profile: state.profiles[message.senderId]!,
              );
            },
          );
        },
      ),
    );
  }
}
