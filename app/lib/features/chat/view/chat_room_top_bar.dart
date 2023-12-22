import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/video_call_button.dart';
import 'package:chat_app/features/chat/view/chat_more_menu.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/user_online_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/common/chat_online_status_icon.dart';
import 'package:flutter/material.dart';

class ChatRoomTopBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const ChatRoomTopBar({
    super.key,
    required this.roomId,
    required this.otherProfile,
  });

  final String roomId;
  final Profile otherProfile;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  ConsumerState<ChatRoomTopBar> createState() => _ChatRoomTopBarState();
}

class _ChatRoomTopBarState extends ConsumerState<ChatRoomTopBar>
    with UserOnlineStatus {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        VideoCallButton(
          buttonType: VideoCallButtonType.chat,
          otherProfile: widget.otherProfile,
        ),
        ChatMoreMenu(
          roomId: widget.roomId,
          otherProfileId: widget.otherProfile.id!,
        ),
      ],
    );
  }
}
