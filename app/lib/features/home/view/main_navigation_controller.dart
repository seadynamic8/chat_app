import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/data/channel_presence_handlers.dart';
import 'package:chat_app/features/home/data/channel_repository.dart';
import 'package:chat_app/features/home/view/call_request_controller.dart';
import 'package:chat_app/features/paywall/data/paywall_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_navigation_controller.g.dart';

@riverpod
class MainNavigationController extends _$MainNavigationController {
  @override
  FutureOr<void> build() async {
    // This is here because while supabase may signout/signin, our app (and riverpod)
    // are still active, so it's still holding on to old currentUserId
    final currentUserId = ref.refresh(currentUserIdProvider)!;

    // Join lobby channel on startup, to notify others that we have signed in
    await ref.watch(lobbySubscribedChannelProvider.future);

    // Join user channel on startup, to be able to receive calls right away
    await setupUserChannel();

    _paywallInitialize(currentUserId);
  }

  Future<void> setupUserChannel() async {
    final currentUserId = ref.watch(currentUserIdProvider)!;

    final myChannel = ref.watch(channelRepositoryProvider(currentUserId));
    await myChannel.subscribed();

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

  void _paywallInitialize(String currentUserId) {
    ref.read(paywallRepositoryProvider).initialize(currentUserId);
  }
}
