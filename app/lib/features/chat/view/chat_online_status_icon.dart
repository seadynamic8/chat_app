import 'package:chat_app/utils/user_online_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/home/application/online_presences.dart';
import 'package:flutter/material.dart';

class ChatOnlineStatusIcon extends ConsumerWidget with UserOnlineStatus {
  const ChatOnlineStatusIcon({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onlinePresences = ref.watch(onlinePresencesProvider);
    final userStatus = getUserOnlineStatus(onlinePresences, userId);

    return Positioned(
      bottom: 0,
      right: 0,
      child: Icon(
        Icons.circle,
        size: 10,
        color: userStatus.color,
      ),
    );
  }
}
