import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/home/application/online_presences.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:chat_app/features/home/view/call_request_controller.dart';
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

  void _acceptCall(String videoRoomId) async {
    logger.t('click accept call');
    final contextRouter = router;

    ref.read(callRequestControllerProvider.notifier).sendAcceptCall();

    closeCallRequestBanner();

    await ref
        .read(onlinePresencesProvider.notifier)
        .updateCurrentUserPresence(OnlineStatus.busy);

    contextRouter.push(VideoRoomRoute(videoRoomId: videoRoomId));
  }

  void _rejectCall() {
    logger.t('click reject call');
    ref.read(callRequestControllerProvider.notifier).sendRejectCall();

    closeCallRequestBanner();
  }

  MaterialBanner _callRequestBanner() {
    final otherUsername =
        ref.watch(callRequestControllerProvider).otherUsername;
    final videoRoomId = ref.watch(callRequestControllerProvider).videoRoomId!;

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
          onPressed: () => _acceptCall(videoRoomId),
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
