import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/common/video_call_button.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat/view/chat_more_menu.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/common/chat_online_status_icon.dart';
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
    final otherProfileValue =
        ref.watch(profileStreamProvider(widget.otherProfileId));

    return AsyncValueWidget(
      value: otherProfileValue,
      data: (otherProfile) => AppBar(
        title: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: const AssetImage(defaultAvatarImage),
                    foregroundImage: otherProfile.avatarUrl == null
                        ? null
                        : NetworkImage(otherProfile.avatarUrl!),
                    radius: 15,
                  ),
                  ChatOnlineStatusIcon(userId: otherProfile.id!)
                ],
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  otherProfile.username!,
                  style: theme.textTheme.labelLarge!.copyWith(
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ),
            ],
          ),
          onTap: () => context.router
              .push(PublicProfileRoute(profileId: otherProfile.id!)),
        ),
        titleSpacing: 5,
        actions: [
          VideoCallButton(
            buttonType: VideoCallButtonType.chat,
            otherProfile: otherProfile,
          ),
          ChatMoreMenu(
            roomId: widget.roomId,
            otherProfileId: otherProfile.id!,
          ),
        ],
      ),
    );
  }
}
