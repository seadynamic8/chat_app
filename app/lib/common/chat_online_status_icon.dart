import 'package:chat_app/features/home/application/online_presence_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ChatOnlineStatusIcon extends ConsumerWidget {
  const ChatOnlineStatusIcon({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onlinePresenceValue = ref.watch(onlinePresenceProvider(userId));

    return onlinePresenceValue.maybeWhen(
      data: (userStatus) {
        return Icon(
          Icons.circle,
          size: 10,
          color: userStatus.color,
        );
      },
      orElse: SizedBox.shrink,
    );
  }
}
