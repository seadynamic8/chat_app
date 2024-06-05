import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/video_call_messages_extension.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/user_access.dart';
import 'package:chat_app/features/video/application/video_service.dart';
import 'package:chat_app/features/video/data/call_availability_provider.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/video/domain/call_availability.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter/material.dart';

enum VideoCallButtonType {
  chat(className: 'ChatRoomTopBar'),
  profile(className: 'PublicProfileScreen');

  const VideoCallButtonType({required this.className});

  final String className;
}

class VideoCallButton extends ConsumerStatefulWidget {
  const VideoCallButton({
    super.key,
    required this.buttonType,
    required this.otherProfileId,
  });

  final VideoCallButtonType buttonType;
  final String otherProfileId;

  @override
  ConsumerState<VideoCallButton> createState() => _VideoCallButtonState();
}

class _VideoCallButtonState extends ConsumerState<VideoCallButton> {
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
      await ref.read(videoServiceProvider).makeVideoCall(widget.otherProfileId);

      router.push(WaitingRoute(otherProfileId: widget.otherProfileId));
    } catch (error, st) {
      if (!mounted) return;
      context.logAndShowError(widget.buttonType.className, error, st);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final callAvailability =
        ref.watch(callAvailabilityProvider(widget.otherProfileId));

    const videoProfileIconSize = 30.0;
    final videoProfileButtonText = Text(
      'Video Call'.i18n,
      style: theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.background,
        fontSize: 15,
      ),
    );

    return switch (widget.buttonType) {
      VideoCallButtonType.chat => callAvailability.maybeWhen(
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
      VideoCallButtonType.profile => callAvailability.maybeWhen(
          data: (callAvailability) => FloatingActionButton.extended(
            icon: Icon(
              callAvailability.status == CallAvailabilityStatus.canCall
                  ? Icons.videocam_rounded
                  : Icons.videocam_off_outlined,
              size: videoProfileIconSize,
            ),
            label: Column(
              children: [
                videoProfileButtonText,
                const VideoButtonPrice(),
              ],
            ),
            heroTag: null,
            onPressed: () => _pressVideoCallButton(callAvailability),
          ),
          orElse: () => FloatingActionButton.extended(
            icon: const Icon(
              Icons.videocam_rounded,
              size: videoProfileIconSize,
            ),
            label: videoProfileButtonText,
            heroTag: null,
            onPressed: null,
          ),
        ),
    };
  }
}

class VideoButtonPrice extends ConsumerWidget {
  const VideoButtonPrice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final accessLevelValue = ref.watch(userAccessStreamProvider
        .select((value) => value.whenData((userAccess) => userAccess?.level)));

    return accessLevelValue.maybeWhen(
      data: (accessLevel) => switch (accessLevel) {
        AccessLevel.trial =>
          Text('Free Trial'.i18n, style: theme.textTheme.labelSmall),
        AccessLevel.standard =>
          Text('Get Premium', style: theme.textTheme.labelSmall),
        _ => const SizedBox.shrink(),
      },
      orElse: SizedBox.shrink,
    );
  }
}
