import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/home/application/online_presences.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:flutter/material.dart';

class ChatOnlineStatusIcon extends ConsumerWidget {
  const ChatOnlineStatusIcon({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStatus = ref
        .watch(onlinePresencesProvider.notifier)
        .getUserOnlineStatus(username);

    return Positioned(
      bottom: 0,
      right: 0,
      child: Icon(
        Icons.circle,
        size: 10,
        color: userStatus == OnlineStatus.offline
            ? Colors.grey
            : userStatus == OnlineStatus.online
                ? Colors.green
                : Colors.red,
      ),
    );
  }
}
