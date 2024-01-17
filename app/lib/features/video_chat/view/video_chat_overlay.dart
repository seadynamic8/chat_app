import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/video_chat/view/video_chat_messages.dart';
import 'package:chat_app/features/video_chat/view/video_chat_new_message.dart';
import 'package:flutter/material.dart';

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
    return !isRemoteReady
        ? Container()
        : Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: VideoChatMessages(otherProfileId: otherProfileId),
              ),
              const VideoChatNewMessage(),
            ],
          );
  }
}
