import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/avatar_image.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat/view/message_bubble.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class MessageTile extends ConsumerWidget {
  const MessageTile(
      {super.key, required this.message, required this.isCurrentUser});

  final Message message;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tileRowItems = [
      MessageTileAvatar(profileId: message.profileId!),
      MessageBubble(message: message, isCurrentUser: isCurrentUser),
      MessageTimestamp(timeString: message.localTime!),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: isCurrentUser ? tileRowItems.reversed.toList() : tileRowItems,
      ),
    );
  }
}

class MessageTileAvatar extends StatelessWidget {
  const MessageTileAvatar({super.key, required this.profileId});

  final String profileId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: AvatarImage(profileId: profileId, radiusSize: 13),
      ),
      onTap: () =>
          context.router.push(PublicProfileRoute(profileId: profileId)),
    );
  }
}

class MessageTimestamp extends StatelessWidget {
  const MessageTimestamp({super.key, required this.timeString});

  final String timeString;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      child: Text(
        timeString,
        style: theme.textTheme.bodySmall!.copyWith(
          color: theme.hintColor.withAlpha(100),
          fontSize: 10,
        ),
      ),
    );
  }
}
