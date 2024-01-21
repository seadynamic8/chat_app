import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/avatar_online_status.dart';
import 'package:chat_app/common/username_widget.dart';
import 'package:chat_app/common/video_call_button.dart';
import 'package:chat_app/features/chat/view/chat_more_menu.dart';
import 'package:chat_app/features/chat/view/user_last_active.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ChatRoomTopBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const ChatRoomTopBar({
    super.key,
    required this.roomId,
    required this.otherProfileId,
  });

  final String roomId;
  final String otherProfileId;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  ConsumerState<ChatRoomTopBar> createState() => _ChatRoomTopBarState();
}

class _ChatRoomTopBarState extends ConsumerState<ChatRoomTopBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AvatarOnlineStatus(
                profileId: widget.otherProfileId, radiusSize: 15),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UsernameWidget(profileId: widget.otherProfileId),
                  UserLastActive(profileId: widget.otherProfileId)
                ],
              ),
            ),
          ],
        ),
        onTap: () => context.router
            .push(PublicProfileRoute(profileId: widget.otherProfileId)),
      ),
      titleSpacing: 5,
      actions: [
        VideoCallButton(
          buttonType: VideoCallButtonType.chat,
          otherProfileId: widget.otherProfileId,
        ),
        ChatMoreMenu(
          roomId: widget.roomId,
          otherProfileId: widget.otherProfileId,
        ),
      ],
    );
  }
}
