import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/video_call_messages_extension.dart';
import 'package:chat_app/features/auth/domain/user_access.dart';
import 'package:chat_app/features/chat/view/chat_more_menu.dart';
import 'package:chat_app/features/video/application/video_service.dart';
import 'package:chat_app/features/video/data/call_availability_provider.dart';
import 'package:chat_app/features/video/domain/call_availability.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/keys.dart';
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
  void _pressVideoCallButton(CallAvailabilityState callAvailability) async {
    switch (callAvailability.status) {
      case CallAvailabilityStatus.unavailable:
        context.showStatusMessage(callAvailability.data);
      case CallAvailabilityStatus.blocked:
        context.showBlockMessage(callAvailability.data);
      case CallAvailabilityStatus.noCoins:
        _showRechargeMessageAndRedirectToPaywall(callAvailability.data);
      case CallAvailabilityStatus.canCall:
        _makeVideoCallAndWait();
    }
  }

  void _showRechargeMessageAndRedirectToPaywall(AccessLevel accessLevel) async {
    final router = context.router;
    final isRecharge = await context.showRechargeMessage(accessLevel);
    if (isRecharge) router.push(const PaywallRoute());
  }

  void _makeVideoCallAndWait() async {
    final router = context.router;
    try {
      await ref.read(videoServiceProvider).makeVideoCall(widget.otherProfile);

      router.push(WaitingRoute(otherProfile: widget.otherProfile));
    } catch (error) {
      if (!context.mounted) return;
      context.logAndShowError('ChatRoomTopBar', error);
    }
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
              callAvailability.status == CallAvailabilityStatus.canCall ||
                      callAvailability.status == CallAvailabilityStatus.noCoins
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
