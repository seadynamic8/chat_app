import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/view/call_request_controller.dart';
import 'package:chat_app/features/video/data/video_api.dart';
import 'package:chat_app/features/video/data/video_settings_provider.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:chat_app/utils/user_online_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/common/chat_online_status_icon.dart';
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

class _ChatRoomTopBarState extends ConsumerState<ChatRoomTopBar>
    with UserOnlineStatus {
  Future<String?> _getVideoRoomId(ScaffoldMessengerState sMessenger) async {
    try {
      final token = await ref.watch(authRepositoryProvider).generateJWTToken();
      final videoRoomId = await ref.watch(videoApiProvider).getRoomId(token);

      ref
          .read(videoSettingsProvider.notifier)
          .updateSettings(token: token, roomId: videoRoomId);

      return videoRoomId;
    } catch (error) {
      logger.e(error.toString());
      return null;
    }
  }

  void _setupVideoCallAndWait(ScaffoldMessengerState sMessenger) async {
    final router = context.router;

    // Create a new video room id
    final videoRoomId = await _getVideoRoomId(sMessenger);
    if (videoRoomId == null) {
      sMessenger.showSnackBar(SnackBar(
        content: Text(
            'Unable to create video call right now, please try again later.'
                .i18n),
      ));
      return;
    }

    // Set online status to busy
    await ref
        .read(onlinePresencesProvider.notifier)
        .updateCurrentUserPresence(OnlineStatus.busy);

    // Send new call
    await ref
        .read(callRequestControllerProvider.notifier)
        .sendNewCall(videoRoomId, widget.otherProfile);

    // Go to waiting route to wait for other user to respond.
    router.push(WaitingRoute(otherProfile: widget.otherProfile));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onlinePresences = ref.watch(onlinePresencesProvider);
    final userStatus =
        getUserOnlineStatus(onlinePresences, widget.otherProfile.id!);

    return AppBar(
      title: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: const AssetImage(defaultAvatarImage),
                  foregroundImage: widget.otherProfile.avatarUrl == null
                      ? null
                      : NetworkImage(widget.otherProfile.avatarUrl!),
                  radius: 15,
                ),
                ChatOnlineStatusIcon(userId: widget.otherProfile.id!)
              ],
            ),
            const SizedBox(width: 15),
            Text(
              widget.otherProfile.username!,
              style: theme.textTheme.labelLarge!.copyWith(
                fontSize: 15,
              ),
            ),
          ],
        ),
        onTap: () => context.router
            .push(PublicProfileRoute(profileId: widget.otherProfile.id!)),
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
          icon: Icon(
            userStatus == OnlineStatus.online
                ? Icons.videocam_rounded
                : Icons.videocam_off_outlined,
            color:
                userStatus == OnlineStatus.online ? Colors.white : Colors.grey,
          ),
        ),
      ],
    );
  }
}
