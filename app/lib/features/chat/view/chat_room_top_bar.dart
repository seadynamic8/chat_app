import 'package:auto_route/auto_route.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/view/chat_online_status_icon.dart';
import 'package:chat_app/features/home/application/online_presences.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:flutter/material.dart';

class ChatRoomTopBar extends ConsumerWidget implements PreferredSizeWidget {
  const ChatRoomTopBar({super.key, required this.otherProfile});

  final Profile otherProfile;

  OnlineStatus getUserStatus(OnlineState? onlineState) {
    if (onlineState == null) return OnlineStatus.offline;
    return onlineState.status;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onlineStates = ref.watch(onlinePresencesProvider);
    final userStatus = getUserStatus(onlineStates[otherProfile.username]);

    return AppBar(
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(otherProfile.avatarUrl ??
                    'assets/images/user_default_image.png'),
                radius: 15,
              ),
              ChatOnlineStatusIcon(username: otherProfile.username!)
            ],
          ),
          const SizedBox(width: 15),
          Text(otherProfile.username!),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            if (userStatus == OnlineStatus.online) {
              context.router.push(WaitingRoute(otherProfile: otherProfile));
              return;
            }
            final sMessenger = ScaffoldMessenger.of(context);
            sMessenger.clearSnackBars();
            sMessenger.showSnackBar(
              SnackBar(
                content: Text(
                  userStatus == OnlineStatus.busy
                      ? 'User is busy right now.'
                      : 'User is offline right now.',
                ),
              ),
            );
          },
          icon: const Icon(Icons.video_call),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
