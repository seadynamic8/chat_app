import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/video_chat/domain/video_chat_message.dart';
import 'package:flutter/material.dart';

class VideoChatMessageBubble extends StatelessWidget {
  const VideoChatMessageBubble(
      {super.key, required this.message, this.profile});

  final VideoChatMessage message;
  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CircleAvatar(
              backgroundImage: AssetImage(
                  profile?.avatarUrl ?? 'assets/images/user_default_image.png'),
              radius: 15,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              boxShadow: const [
                BoxShadow(color: Colors.black45),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            child: Column(
              children: [
                Text(
                  message.content,
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontSize: 13,
                    color: Colors.white,
                    shadows: [
                      const Shadow(
                          color: Colors.white,
                          blurRadius: 1,
                          offset: Offset(0.2, 0.2)),
                    ],
                  ),
                ),
                if (message.translation != null)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [
                        BoxShadow(color: Colors.white30),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    child: Text(
                      message.translation!,
                      style: theme.textTheme.bodySmall!.copyWith(
                        fontSize: 13,
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                              color: Colors.white,
                              blurRadius: 1,
                              offset: Offset(0.2, 0.2)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}