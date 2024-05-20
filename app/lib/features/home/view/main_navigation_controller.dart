import 'package:chat_app/common/remote_error_repository.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/data/channel_repository.dart';
import 'package:chat_app/features/home/view/call_request_controller.dart';
import 'package:chat_app/features/paywall/data/paywall_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_navigation_controller.g.dart';

@riverpod
class MainNavigationController extends _$MainNavigationController {
  @override
  FutureOr<void> build() async {
    _refreshCurrentUserId();
    await _setupLobbyChannel();
    await _setupUserChannel();

    await ref.watch(remoteErrorProvider).setCurrentUser();

    ref.watch(paywallServiceProvider);
  }

  // This is here because while supabase may signout/signin, our app (and riverpod)
  // are still active, so it's still holding on to old currentUserId
  void _refreshCurrentUserId() {
    ref.invalidate(currentUserIdProvider);
  }

  // Join lobby channel on startup, to notify others that we have signed in
  Future<void> _setupLobbyChannel() async {
    await ref.watch(lobbySubscribedChannelProvider.future);
  }

  // Join user channel on startup, to be able to receive calls right away
  Future<void> _setupUserChannel() async {
    final currentProfile = await ref.read(currentProfileStreamProvider.future);
    if (currentProfile == null) {
      throw Exception('Current profile is null');
    }

    final myChannel = await ref
        .watch(userSubscribedChannelProvider(currentProfile.username!).future);

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
  }
}
