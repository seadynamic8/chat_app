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
                      ? Colors.grey[700]
                      : themeContext.colorScheme.secondary,
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
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Column(
                  crossAxisAlignment: isCurrentUser(ref)
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 4),
                      child: Text(
                        message.content,
                        style: TextStyle(
                          height: 1.3,
                          color: isCurrentUser(ref)
                              ? themeContext.colorScheme.onBackground
                                  .withAlpha(200)
                              : themeContext.colorScheme.onSecondary,
                        ),
                        softWrap: true,
                      ),
                    ),
                    if (message.translation != null && !isCurrentUser(ref))
                      Container(
                        decoration: BoxDecoration(
                          color: isCurrentUser(ref)
                              ? Colors.grey.withAlpha(200)
                              : themeContext.colorScheme.background
                                  .withAlpha(100),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.zero,
                            topRight: Radius.zero,
                            bottomLeft: Radius.circular(9),
                            bottomRight: Radius.circular(9),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 4),
                        child: Text(
                          message.translation!,
                          style: TextStyle(
                            height: 1.3,
                            color: isCurrentUser(ref)
                                ? Colors.black87
                                : themeContext.colorScheme.onBackground
                                    .withAlpha(200),
                          ),
                          softWrap: true,
                        ),
                      ),
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
