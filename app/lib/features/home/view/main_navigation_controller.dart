import 'package:chat_app/common/remote_error_repository.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/application/current_user_id_provider.dart';
import 'package:chat_app/features/home/data/channel_repository.dart';
import 'package:chat_app/features/home/view/call_request_controller.dart';
import 'package:chat_app/features/paywall/data/paywall_service.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_navigation_controller.g.dart';

@riverpod
class MainNavigationController extends _$MainNavigationController {
  @override
  FutureOr<void> build() async {
    try {
      final currentUserId = ref.watch(currentUserIdProvider);
      if (currentUserId == null) return;

      await _setupLobbyChannel();
      await _setupUserChannel();

      await ref.watch(remoteErrorProvider).setCurrentUser();

      ref.watch(paywallServiceProvider);
    } catch (error, st) {
      logger.error('MainNavigationController.build()', error, st);
    }
  }

  Future<void> _setupLobbyChannel() async {
    // Join lobby channel on startup, to notify others that we have signed in
    final lobbyChannel = await ref.watch(lobbySubscribedChannelProvider.future);

    // - Listen to lobby updates to cache call to ensure only read once,
    // but don't need updates here, so no callback work is being done.
    // - Listen instead of watch, don't rebuild when updates.
    ref.listen(
        lobbyUpdatePresenceStreamProvider(lobbyChannel), (_, presences) => ());
  }

  // Join user channel on startup, to be able to receive calls right away
  Future<void> _setupUserChannel() async {
    try {
      final currentProfile =
          await ref.watch(currentProfileStreamProvider.future);

      if (currentProfile == null) return;

      final myChannel = await ref.watch(
          userSubscribedChannelProvider(currentProfile.username!).future);

      // Interesting, here, don't need to delay after subscribe to add callback handlers

      final callRequestController =
          ref.read(callRequestControllerProvider.notifier);

      // Callee receives
      myChannel.on('new_call', callRequestController.onNewCall);
      myChannel.on('cancel_call', callRequestController.onCancelCall);

      // Caller receives
      myChannel.on('accept_call', callRequestController.onAcceptCall);
      myChannel.on('reject_call', callRequestController.onRejectCall);

      // Call ended
      myChannel.on('end_call', callRequestController.onEndCall);
    } catch (error, st) {
      logger.error('_setupUserChannel()', error, st);
    }
  }
}
