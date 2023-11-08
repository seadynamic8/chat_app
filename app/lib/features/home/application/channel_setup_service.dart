import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/application/online_presences.dart';
import 'package:chat_app/features/home/data/channel_presence_handlers.dart';
import 'package:chat_app/features/home/data/channel_repository.dart';
import 'package:chat_app/features/home/view/incoming_call_controller.dart';
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
      (previous, next) {
        final currentState = next.value;
        if (currentState != null) {
          final event = currentState.event;
          switch (event) {
            case AuthChangeEvent.signedIn:
              logger.i('sign in');
              _setupLobbyChannel();
              _setupUserChannel();
              break;
            case AuthChangeEvent.signedOut:
              logger.i('sign out');
              _closeLobbyChannel();
              break;
            default:
              break;
          }
        }
      },
    );
  }

  // Join lobby channel on startup, to notify others that we have signed on
  void _setupLobbyChannel() async {
    final lobbyChannel = await ref
        .refresh(lobbySubscribedChannelProvider(lobbyChannelName).future);
    final updateHandler =
        ref.read(onlinePresencesProvider.notifier).updateAllPresences;
    lobbyChannel.onUpdate(updateHandler);
  }

  void _closeLobbyChannel() async {
    // Unsubscribe from the channel
    final lobbyChannel =
        await ref.read(lobbySubscribedChannelProvider(lobbyChannelName).future);
    lobbyChannel.close();
  }

  void _setupUserChannel() async {
    final currentUserName = ref.watch(authRepositoryProvider).currentUserName!;

    final myChannel = ref.watch(channelRepositoryProvider(currentUserName));
    await myChannel.subscribed();

    // Interesting, here, don't need to delay after subscribe to add callback handlers

    final incomingCallController =
        ref.read(incomingCallControllerProvider.notifier);

    myChannel.on('new_call', incomingCallController.setIncomingCall);
    myChannel.on('cancel_call', incomingCallController.setCancelCall);
  }
}

@Riverpod(keepAlive: true)
ChannelSetupService channelSetupService(ChannelSetupServiceRef ref) {
  return ChannelSetupService(ref: ref);
}
