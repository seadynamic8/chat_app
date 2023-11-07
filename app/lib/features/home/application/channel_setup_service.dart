import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/application/online_presences.dart';
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
        final onlinePresences = ref.watch(onlinePresencesProvider.notifier);

        final currentState = next.value;
        if (currentState != null) {
          final event = currentState.event;
          switch (event) {
            case AuthChangeEvent.signedIn:
              _setupLobbyChannel(onlinePresences);
              break;
            case AuthChangeEvent.signedOut:
              _closeLobbyChannel(onlinePresences);
              break;
            default:
              break;
          }
        }
      },
    );
  }

  // Join lobby channel on startup, to notify others that we have signed on
  void _setupLobbyChannel(OnlinePresences onlinePresences) {
    ref.watch(lobbySubscribedChannelProvider(
        lobbyChannelName, onlinePresences.updateHandler));
  }

  void _closeLobbyChannel(OnlinePresences onlinePresences) async {
    // Unsubscribe from the channel
    final lobbyChannel = await ref.read(lobbySubscribedChannelProvider(
            lobbyChannelName, onlinePresences.updateHandler)
        .future);
    lobbyChannel.close();

    // Invalidate the channel so that it refreshes on login
    ref.invalidate(lobbySubscribedChannelProvider(
        lobbyChannelName, onlinePresences.updateHandler));
  }
}

@Riverpod(keepAlive: true)
ChannelSetupService channelSetupService(ChannelSetupServiceRef ref) {
  return ChannelSetupService(ref: ref);
}
