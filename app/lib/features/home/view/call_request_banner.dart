import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/application/online_presences.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:chat_app/features/home/view/call_request_controller.dart';
import 'package:chat_app/features/video/data/video_settings_provider.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallRequestBanner {
  CallRequestBanner({
    required this.sMessenger,
    required this.ref,
    required this.router,
  });

  final ScaffoldMessengerState sMessenger;
  final WidgetRef ref;
  final StackRouter router;

  void showCallRequestBanner() {
    logger.t('show call request banner');
    sMessenger.clearMaterialBanners();
    sMessenger.showMaterialBanner(_callRequestBanner());
  }

  void closeCallRequestBanner() {
    logger.t('close call request banner');
    sMessenger.hideCurrentMaterialBanner();
  }

  void _acceptCall() async {
    logger.t('click accept call');
    final contextRouter = router;
    final callRequestState = ref.read(callRequestControllerProvider);

    await ref.read(callRequestControllerProvider.notifier).sendAcceptCall();

    closeCallRequestBanner();

    await ref
        .read(onlinePresencesProvider.notifier)
        .updateCurrentUserPresence(OnlineStatus.busy);

    final token = await ref.read(authRepositoryProvider).generateJWTToken();
    ref
        .read(videoSettingsProvider.notifier)
        .updateSettings(token: token, roomId: callRequestState.videoRoomId!);

    contextRouter.push(
      VideoRoomRoute(
          videoRoomId: callRequestState.videoRoomId!,
          otherProfileId: callRequestState.otherUserId!),
    );
  }

  void _rejectCall() {
    logger.t('click reject call');
    ref.read(callRequestControllerProvider.notifier).sendRejectCall();

    closeCallRequestBanner();
  }

  MaterialBanner _callRequestBanner() {
    final otherUsername =
        ref.watch(callRequestControllerProvider).otherUsername;

    return MaterialBanner(
      leading: const Icon(Icons.info_outline),
      content: Text('Incoming Call from: $otherUsername'),
      elevation: 1,
      padding: const EdgeInsets.all(8),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.call,
            color: Colors.green,
          ),
          onPressed: () => _acceptCall(),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(
            Icons.call_end,
            color: Colors.red,
          ),
          onPressed: () => _rejectCall(),
        ),
      ],
    );
  }
}
