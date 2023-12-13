import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/error_snackbar.dart';
import 'package:chat_app/features/auth/domain/block_state.dart';
import 'package:chat_app/features/chat/view/chat_more_menu.dart';
import 'package:chat_app/features/video/application/video_service.dart';
import 'package:chat_app/features/video/data/call_availability_provider.dart';
import 'package:chat_app/features/video/domain/call_availability.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:chat_app/utils/user_online_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/common/chat_online_status_icon.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
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
  void _pressVideoCallButton(CallAvailabilityState callAvailability) async {
    switch (callAvailability.status) {
      case CallAvailabilityStatus.unavailable:
        _showStatusMessage(callAvailability.data);
      case CallAvailabilityStatus.blocked:
        _showBlockMessage(callAvailability.data);
      case CallAvailabilityStatus.canCall:
        _makeVideoCallAndWait();
    }
  }

  void _makeVideoCallAndWait() async {
    final router = context.router;
    try {
      await ref.read(videoServiceProvider).makeVideoCall(widget.otherProfile);

      router.push(WaitingRoute(otherProfile: widget.otherProfile));
    } catch (error) {
      _logAndShowError(error);
    }
  }

  void _showStatusMessage(OnlineStatus userStatus) {
    context.showSnackBar(userStatus == OnlineStatus.busy
        ? 'User is busy right now.'.i18n
        : 'User is offline right now.'.i18n);
  }

  void _showBlockMessage(BlockState blockState) {
    context.showErrorSnackBar('${blockState.message}, cannot video call');
  }

  void _logAndShowError(error) {
    logger.e('ChatRoomTopBar Error: $error');

    if (!context.mounted) return;
    context.showSnackBar(
        'Unable to create video call right now, please try again later.'.i18n);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final callAvailability =
        ref.watch(callAvailabilityProvider(widget.otherProfile.id!));

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
        callAvailability.maybeWhen(
          data: (callAvailability) => IconButton(
            key: K.chatRoomVideoCallButton,
            onPressed: () => _pressVideoCallButton(callAvailability),
            icon: Icon(
              callAvailability.status == CallAvailabilityStatus.canCall
                  ? Icons.videocam_rounded
                  : Icons.videocam_off_outlined,
              color: callAvailability.status == CallAvailabilityStatus.canCall
                  ? Colors.white
                  : Colors.grey,
            ),
          ),
          orElse: SizedBox.shrink,
        ),
        ChatMoreMenu(
          roomId: widget.roomId,
          otherProfileId: widget.otherProfile.id!,
        ),
      ],
    );
  }
}
