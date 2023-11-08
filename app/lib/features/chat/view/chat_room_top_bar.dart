import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/view/incoming_call_controller.dart';
import 'package:chat_app/features/video/data/video_repository.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/view/chat_online_status_icon.dart';
import 'package:chat_app/features/home/application/online_presences.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:flutter/material.dart';

class ChatRoomTopBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const ChatRoomTopBar({super.key, required this.otherProfile});

  final Profile otherProfile;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  ConsumerState<ChatRoomTopBar> createState() => _ChatRoomTopBarState();
}

class _ChatRoomTopBarState extends ConsumerState<ChatRoomTopBar> {
  Future<String?> _getVideoRoomId() async {
    // Create room id (with token)
    final token = await ref.watch(authRepositoryProvider).generateJWTToken();
    return await ref.watch(videoRepositoryProvider).getRoomId(token);
  }

  void _setupVideoCallAndWait(ScaffoldMessengerState sMessenger) async {
    final router = context.router;

    // Create a new video room id
    final videoRoomId = await _getVideoRoomId();
    if (videoRoomId == null) {
      sMessenger.showSnackBar(const SnackBar(
          content: Text('Something went wrong, please try again later.')));
      return;
    }

    // Set online status to busy
    await ref
        .read(onlinePresencesProvider.notifier)
        .updateCurrentUserPresence(OnlineStatus.busy);

    // Send new call
    await ref
        .read(incomingCallControllerProvider.notifier)
        .sendNewCall(videoRoomId, widget.otherProfile.username!);

    // Go to waiting route to wait for other user to respond.
    router.push(WaitingRoute(
        videoRoomId: videoRoomId, otherProfile: widget.otherProfile));
  }

  @override
  Widget build(BuildContext context) {
    final userStatus = ref
        .watch(onlinePresencesProvider.notifier)
        .getUserOnlineStatus(widget.otherProfile.username!);

    return AppBar(
      title: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(widget.otherProfile.avatarUrl ??
                      'assets/images/user_default_image.png'),
                  radius: 15,
                ),
                ChatOnlineStatusIcon(username: widget.otherProfile.username!)
              ],
            ),
            const SizedBox(width: 15),
            Text(widget.otherProfile.username!),
          ],
        ),
        onTap: () => context.router
            .push(PublicProfileRoute(profileId: widget.otherProfile.id)),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            final sMessenger = ScaffoldMessenger.of(context);
            sMessenger.clearSnackBars();

            if (userStatus == OnlineStatus.online) {
              _setupVideoCallAndWait(sMessenger);
            } else {
              sMessenger.showSnackBar(
                SnackBar(
                  content: Text(
                    userStatus == OnlineStatus.busy
                        ? 'User is busy right now.'
                        : 'User is offline right now.',
                  ),
                ),
              );
            }
          },
          icon: const Icon(Icons.video_call),
        ),
      ],
    );
  }
}
