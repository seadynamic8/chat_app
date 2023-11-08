import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/home/application/online_presences.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:chat_app/features/home/view/call_request_controller.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncomingCallBanner {
  IncomingCallBanner({
    required this.sMessenger,
    required this.ref,
    required this.router,
  });

  final ScaffoldMessengerState sMessenger;
  final WidgetRef ref;
  final StackRouter router;

  void showIncomingCallBanner(String otherUsername, String videoRoomId) {
    logger.t('show incoming call banner');
    sMessenger.clearMaterialBanners();
    sMessenger
        .showMaterialBanner(_incomingCallBanner(otherUsername, videoRoomId));
  }

  void closeIncomingCallBanner() {
    logger.t('close incoming call banner');
    sMessenger.hideCurrentMaterialBanner();
  }

  void _acceptCall(String otherUsername, String videoRoomId) async {
    logger.t('click accept call');
    final contextRouter = router;

    ref.read(callRequestControllerProvider.notifier).sendAcceptCall();

    closeIncomingCallBanner();

    await ref
        .read(onlinePresencesProvider.notifier)
        .updateCurrentUserPresence(OnlineStatus.busy);

    contextRouter.push(VideoRoomRoute(videoRoomId: videoRoomId));
  }

  void _rejectCall(String otherUsername) {
    logger.t('click reject call');
    ref.read(callRequestControllerProvider.notifier).sendRejectCall();

    closeIncomingCallBanner();
  }

  MaterialBanner _incomingCallBanner(String otherUsername, String videoRoomId) {
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
          onPressed: () => _acceptCall(otherUsername, videoRoomId),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(
            Icons.call_end,
            color: Colors.red,
          ),
          onPressed: () => _rejectCall(otherUsername),
        ),
      ],
    );
  }
}
