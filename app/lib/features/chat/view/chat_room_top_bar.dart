import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/common/avatar_online_status.dart';
import 'package:chat_app/common/video_call_button.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat/view/chat_more_menu.dart';
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
    final theme = Theme.of(context);
    final otherUsernameValue = ref.watch(
        profileStreamProvider(widget.otherProfileId)
            .select((value) => value.whenData((profile) => profile.username)));

    return AppBar(
      title: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AvatarOnlineStatus(
                profileId: widget.otherProfileId, radiusSize: 15),
            const SizedBox(width: 15),
            Expanded(
              child: AsyncValueWidget(
                value: otherUsernameValue,
                data: (otherUsername) => Text(
                  otherUsername!,
                  style: theme.textTheme.labelLarge!.copyWith(
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
                showLoading: false,
                showError: false,
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
