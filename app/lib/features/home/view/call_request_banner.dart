import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/home/application/online_presences.dart';
import 'package:chat_app/features/home/domain/call_request_state.dart';
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

  void _acceptCall(CallRequestState callRequestState) async {
    logger.t('click accept call');
    final contextRouter = router;

    ref.read(callRequestControllerProvider.notifier).sendAcceptCall();

    closeCallRequestBanner();

    await ref
        .read(onlinePresencesProvider.notifier)
        .updateCurrentUserPresence(OnlineStatus.busy);

    contextRouter.push(VideoRoomRoute(
      videoRoomId: callRequestState.videoRoomId!,
      otherProfile: Profile(
        id: callRequestState.otherUserId!,
        username: callRequestState.otherUsername,
      ),
    ));
  }

  void _rejectCall() {
    logger.t('click reject call');
    ref.read(callRequestControllerProvider.notifier).sendRejectCall();

    closeCallRequestBanner();
  }

  MaterialBanner _callRequestBanner() {
    final callRequestState = ref.watch(callRequestControllerProvider);

    return MaterialBanner(
      leading: const Icon(Icons.info_outline),
      content: Text('Incoming Call from: ${callRequestState.otherUsername}'),
      elevation: 1,
      padding: const EdgeInsets.all(8),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.call,
            color: Colors.green,
          ),
          onPressed: () => _acceptCall(callRequestState),
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
