import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/avatar_image.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat/view/message_bubble_content.dart';
import 'package:chat_app/features/chat/view/message_bubble_translation.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class MessageBubble extends ConsumerWidget {
  const MessageBubble(
      {super.key, required this.message, required this.isCurrentUser});

  final Message message;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final messageBodyItems = [
      ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.60),
        child: Container(
          decoration: BoxDecoration(
            color:
                isCurrentUser ? Colors.grey[700] : theme.colorScheme.secondary,
            borderRadius: BorderRadius.only(
              topLeft: !isCurrentUser ? Radius.zero : const Radius.circular(12),
              topRight: isCurrentUser ? Radius.zero : const Radius.circular(12),
              bottomLeft: const Radius.circular(12),
              bottomRight: const Radius.circular(12),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              MessageBubbleContent(
                message: message,
                isCurrentUser: isCurrentUser,
              ),
              if (message.translation != null && !isCurrentUser)
                MessageBubbleTranslation(
                  translation: message.translation!,
                  isCurrentUser: isCurrentUser,
                )
            ],
          ),
        ),
      ),

      // TIMESTAMP
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        child: Text(
          message.localTime!,
          style: theme.textTheme.bodySmall!.copyWith(
            color: theme.hintColor.withAlpha(100),
            fontSize: 10,
          ),
        ),
      )
    ];

    return Stack(
      children: [
        Positioned(
          right: isCurrentUser ? 0 : null,
          child: InkWell(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: AvatarImage(profileId: message.profileId!, radiusSize: 13),
            ),
            onTap: () => context.router
                .push(PublicProfileRoute(profileId: message.profileId!)),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 42),
          child: Row(
            mainAxisAlignment:
                isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: isCurrentUser
                ? messageBodyItems.reversed.toList()
                : messageBodyItems,
          ),
        ),
      ],
    );
  }
}
