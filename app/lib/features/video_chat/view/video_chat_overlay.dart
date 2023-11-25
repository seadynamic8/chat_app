import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/video_chat/view/video_chat_messages.dart';
import 'package:chat_app/features/video_chat/view/video_chat_new_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class VideoChatOverlay extends ConsumerWidget {
  const VideoChatOverlay({
    super.key,
    required this.isRemoteReady,
    required this.otherProfileId,
  });

  final bool isRemoteReady;
  final String otherProfileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuerySize = MediaQuery.sizeOf(context);
    final isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    // This gets inserted into a stack on VideoRoomScreen
    return !isRemoteReady
        ? Container()
        : SizedBox(
            height: isKeyboardVisible
                ? mediaQuerySize.height * 0.45
                : mediaQuerySize.height * 0.65,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: VideoChatMessages(otherProfileId: otherProfileId),
                ),
                const VideoChatNewMessage(),
              ],
            ),
          );
  }
}
