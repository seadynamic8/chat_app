import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/application/online_presences.dart';
import 'package:chat_app/features/home/data/channel_presence_handlers.dart';
import 'package:chat_app/features/home/data/channel_repository.dart';
import 'package:chat_app/features/home/view/call_request_controller.dart';
import 'package:chat_app/features/paywall/data/paywall_repository.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'channel_setup_service.g.dart';

class ChannelSetupService {
  ChannelSetupService({required this.ref}) {
    _init();
  }

  final Ref ref;

  void _init() {
    _listenToAppLifecycleChanges();

    ref.listen<AsyncValue<AuthState>>(
      authStateChangesProvider,
      (previous, next) async {
        final currentState = next.value;
        if (currentState != null) {
          final event = currentState.event;
          switch (event) {
            case AuthChangeEvent.signedIn:
            case AuthChangeEvent.tokenRefreshed:
              logger.i('sign in');
              _refreshCurrentUserId();
              await setupLobbyChannel();
              await setupUserChannel();
              _paywallInitialize();

            // Necessary to reload after password reset
            case AuthChangeEvent.userUpdated:
              logger.i('user updated event');
              _refreshCurrentUserId();
            case AuthChangeEvent.signedOut:
              logger.i('sign out');
              await _paywallLogut();
            default:
          }
        }
      },
    );
  }

  // This is here because while supabase may signout/signin, our app (and riverpod)
  // are still active, so it's still holding on to old currentUserId
  Future<void> _refreshCurrentUserId() async {
    ref.invalidate(currentUserIdProvider);
  }

  // Join lobby channel on startup, to notify others that we have signed on
  Future<void> setupLobbyChannel() async {
    final isLoggedIn = ref.read(authRepositoryProvider).currentSession != null;
    if (!isLoggedIn) return;

    final lobbyChannel = await ref
        .refresh(lobbySubscribedChannelProvider(lobbyChannelName).future);
    final updateHandler =
        ref.read(onlinePresencesProvider.notifier).updateAllPresences;
    lobbyChannel.onUpdate(updateHandler);
  }

  Future<void> closeLobbyChannel() async {
    // Unsubscribe from the channel
    final lobbyChannel =
        await ref.read(lobbySubscribedChannelProvider(lobbyChannelName).future);
    await lobbyChannel.close();
  }

  Future<void> setupUserChannel() async {
    final isLoggedIn = ref.read(authRepositoryProvider).currentSession != null;
    if (!isLoggedIn) return;

    final currentUserId = ref.read(currentUserIdProvider)!;

    final myChannel = ref.refresh(channelRepositoryProvider(currentUserId));
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

  Future<void> closeUserChannel() async {
    final currentProfileId = ref.read(currentUserIdProvider);

    if (currentProfileId == null) return;

    final myChannel = ref.read(channelRepositoryProvider(currentProfileId));
    await myChannel.close();
  }

  void _paywallInitialize() async {
    final currentUserId = ref.read(currentUserIdProvider)!;
    ref.read(paywallRepositoryProvider).initialize(currentUserId);
  }

  Future<void> _paywallLogut() async {
    await ref.read(paywallRepositoryProvider).paywallLogout();
  }

  void _listenToAppLifecycleChanges() {
    AppLifecycleListener(onStateChange: _onStateChanged);
  }

  void _onStateChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        logger.i('appState: paused');
        closeLobbyChannel();
        closeUserChannel();
      case AppLifecycleState.resumed:
        logger.i('appState: resumed');
        setupLobbyChannel();
        setupUserChannel();
      case AppLifecycleState.inactive:
        logger.t('appState: inactive');
      case AppLifecycleState.detached:
        logger.t('appState: detached');
      case AppLifecycleState.hidden:
        logger.t('appState: hidden');
      default:
    }
  }
}

@riverpod
ChannelSetupService channelSetupService(ChannelSetupServiceRef ref) {
  return ChannelSetupService(ref: ref);
}
