import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat/view/message_bubble_content.dart';
import 'package:chat_app/features/chat/view/message_bubble_translation.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class MessageBubble extends ConsumerWidget {
  const MessageBubble({super.key, required this.message, this.profile});

  final Message message;
  final Profile? profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeContext = Theme.of(context);
    final currentUserId = ref.watch(authRepositoryProvider).currentUserId!;
    final isCurrentUser = message.profileId == currentUserId;

    return Stack(
      children: [
        Positioned(
          right: isCurrentUser ? 0 : null,
          child: InkWell(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: CircleAvatar(
                backgroundImage: AssetImage(profile?.avatarUrl ??
                    'assets/images/user_default_image.png'),
                radius: 15,
              ),
            ),
            onTap: () =>
                context.router.push(PublicProfileRoute(profileId: profile!.id)),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 46),
          child: Row(
            mainAxisAlignment:
                isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isCurrentUser
                      ? Colors.grey[700]
                      : themeContext.colorScheme.secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: !isCurrentUser
                        ? Radius.zero
                        : const Radius.circular(12),
                    topRight:
                        isCurrentUser ? Radius.zero : const Radius.circular(12),
                    bottomLeft: const Radius.circular(12),
                    bottomRight: const Radius.circular(12),
                  ),
                ),
                constraints: const BoxConstraints(maxWidth: 200),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Column(
                  crossAxisAlignment: isCurrentUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    MessageBubbleContent(
                      content: message.content,
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
            ],
          ),
        ),
      ],
    );
  }
}
