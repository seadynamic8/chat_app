import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/application/online_presences.dart';
import 'package:chat_app/features/home/data/channel_presence_handlers.dart';
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
              _setupLobbyChannel();
              break;
            case AuthChangeEvent.signedOut:
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
        ref.watch(onlinePresencesProvider.notifier).updatePresences;
    lobbyChannel.onUpdate(updateHandler);
  }

  void _closeLobbyChannel() async {
    // Unsubscribe from the channel
    final lobbyChannel =
        await ref.read(lobbySubscribedChannelProvider(lobbyChannelName).future);
    lobbyChannel.close();
  }
}

@Riverpod(keepAlive: true)
ChannelSetupService channelSetupService(ChannelSetupServiceRef ref) {
  return ChannelSetupService(ref: ref);
}
