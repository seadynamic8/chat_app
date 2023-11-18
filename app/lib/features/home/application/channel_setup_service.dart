import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/data/current_profile_provider.dart';
import 'package:chat_app/features/home/application/app_locale_provider.dart';
import 'package:chat_app/features/home/application/online_presences.dart';
import 'package:chat_app/features/home/data/channel_presence_handlers.dart';
import 'package:chat_app/features/home/data/channel_repository.dart';
import 'package:chat_app/features/home/view/call_request_controller.dart';
import 'package:chat_app/utils/logger.dart';
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
    ref.listen<AsyncValue<AuthState>>(
      authStateChangesProvider,
      (previous, next) async {
        final currentState = next.value;
        if (currentState != null) {
          final event = currentState.event;
          switch (event) {
            case AuthChangeEvent.signedIn:
            case AuthChangeEvent.tokenRefreshed:
            case AuthChangeEvent.userUpdated:
              logger.i('sign in');
              await _loadUserProfile();
              _setLocale();
              await setupLobbyChannel();
              await setupUserChannel();
              break;
            case AuthChangeEvent.signedOut:
              logger.i('sign out');
              closeLobbyChannel();
              closeUserChannel();
              break;
            default:
              break;
          }
        }
      },
    );
  }

  Future<void> _loadUserProfile() async {
    await ref.read(currentProfileProvider.notifier).load();
  }

  void _setLocale() {
    final currentProfile = ref.read(currentProfileProvider);
    final currentLocale = ref.read(appLocaleProvider);

    if (currentLocale != currentProfile.language!) {
      ref.read(appLocaleProvider.notifier).set(currentProfile.language!);
    }
  }

  // Join lobby channel on startup, to notify others that we have signed on
  Future<void> setupLobbyChannel() async {
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
    lobbyChannel.close();
  }

  Future<void> setupUserChannel() async {
    final currentUserId = ref.read(authRepositoryProvider).currentUserId!;

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
    // Here we need to use currentProfileProvider since authRepository is gone after signOut
    final currentProfileId = ref.read(currentProfileProvider).id!;

    final myChannel = ref.read(channelRepositoryProvider(currentProfileId));
    myChannel.close();
  }
}

@Riverpod(keepAlive: true)
ChannelSetupService channelSetupService(ChannelSetupServiceRef ref) {
  return ChannelSetupService(ref: ref);
}
