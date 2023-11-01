import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class MessageBubble extends ConsumerWidget {
  const MessageBubble({super.key, required this.message, this.profile});

  final Message message;
  final Profile? profile;

  bool isCurrentUser(WidgetRef ref) {
    final currentUserId = ref.watch(authRepositoryProvider).currentUserId!;
    return message.profileId == currentUserId;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeContext = Theme.of(context);

    return Stack(
      children: [
        Positioned(
          right: isCurrentUser(ref) ? 0 : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: CircleAvatar(
              backgroundImage: AssetImage(
                  profile?.avatarUrl ?? 'assets/images/user_default_image.png'),
              radius: 15,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 46),
          child: Row(
            mainAxisAlignment: isCurrentUser(ref)
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isCurrentUser(ref)
                      ? Colors.grey[300]
                      : themeContext.colorScheme.secondary.withAlpha(200),
                  borderRadius: BorderRadius.only(
                    topLeft: !isCurrentUser(ref)
                        ? Radius.zero
                        : const Radius.circular(12),
                    topRight: isCurrentUser(ref)
                        ? Radius.zero
                        : const Radius.circular(12),
                    bottomLeft: const Radius.circular(12),
                    bottomRight: const Radius.circular(12),
                  ),
                ),
                constraints: const BoxConstraints(maxWidth: 200),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                child: Text(
                  message.content,
                  style: TextStyle(
                    height: 1.3,
                    color: isCurrentUser(ref)
                        ? Colors.black87
                        : themeContext.colorScheme.onSecondary,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
