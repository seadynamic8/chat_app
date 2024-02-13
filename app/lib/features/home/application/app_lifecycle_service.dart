import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/data/channel_repository.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_lifecycle_service.g.dart';

class AppLifecycleService {
  AppLifecycleService({required this.ref}) {
    _init();
  }

  final Ref ref;

  void _init() {
    _listenToAppLifecycleChanges();
  }

  void _listenToAppLifecycleChanges() {
    AppLifecycleListener(onStateChange: _onStateChanged);
  }

  void _onStateChanged(AppLifecycleState state) async {
    try {
      switch (state) {
        case AppLifecycleState.paused:
          logger.i('appState: paused');
          await setOfflineTimestamp();
          await closeLobbyChannel();
          await closeUserChannel();
        case AppLifecycleState.resumed:
          logger.i('appState: resumed');
        case AppLifecycleState.inactive:
          logger.t('appState: inactive');
        case AppLifecycleState.detached:
          logger.t('appState: detached');
        case AppLifecycleState.hidden:
          logger.t('appState: hidden');
        default:
      }
    } catch (error, st) {
      logger.error('_onStateChanged()', error, st);
    }
  }

  Future<void> setOfflineTimestamp() async {
    if (_notLoggedIn()) return;
    await ref.read(authRepositoryProvider).setOfflineAt();
  }

  Future<void> closeLobbyChannel() async {
    // Make sure to invalidate the actual channel and not subscribed channel as
    // that doesn't do anything then.
    ref.invalidate(channelRepositoryProvider(lobbyChannelName));
  }

  Future<void> closeUserChannel() async {
    final currentProfileId = ref.read(currentUserIdProvider);
    if (currentProfileId == null) return;
    ref.invalidate(channelRepositoryProvider(currentProfileId));
  }

  bool _notLoggedIn() {
    // Don't use currentUserIdProvider (since it's cached, use the actual value)
    final currentSession = ref.read(authRepositoryProvider).currentSession;
    final isSessionExpired = currentSession?.isExpired ?? true;

    return currentSession == null || isSessionExpired;
  }
}

@riverpod
AppLifecycleService appLifecycleService(AppLifecycleServiceRef ref) {
  return AppLifecycleService(ref: ref);
}
