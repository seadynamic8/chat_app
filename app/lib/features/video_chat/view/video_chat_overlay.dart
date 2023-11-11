import 'package:chat_app/features/video/view/video_room_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/video_chat/view/video_chat_messages.dart';
import 'package:chat_app/features/video_chat/view/video_chat_new_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class VideoChatOverlay extends ConsumerWidget {
  const VideoChatOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoRoomState = ref.watch(videoRoomControllerProvider);

    final mediaQuery = MediaQuery.of(context);
    final isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    // This gets inserted into a stack on VideoRoomScreen
    return !videoRoomState.value!.remoteJoined
        ? Container()
        : SizedBox(
            height: isKeyboardVisible
                ? mediaQuery.size.height * 0.45
                : mediaQuery.size.height * 0.65,
            width: double.infinity,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: VideoChatMessages(),
                ),
                VideoChatNewMessage(),
              ],
            ),
          );
  }
}
