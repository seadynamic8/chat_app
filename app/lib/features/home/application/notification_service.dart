import 'dart:async';

import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/token.dart';
import 'package:chat_app/features/home/data/notification_repository.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service.g.dart';

class NotificationService {
  NotificationService({required this.ref, required this.notifications});

  final Ref ref;
  final NotificationRepository notifications;
  StreamSubscription<String>? _tokenRefreshSubscription;

  Future<NotificationRepository> initialize() async {
    final isPermitted = await _initPermssions();
    if (!isPermitted) return notifications;

    final tokensInitialized = await _initTokens();
    if (!tokensInitialized) return notifications;

    await notifications.setupIOSNotifications();

    return notifications;
  }

  Future<void> deleteToken() async {
    final token = await notifications.getToken();
    if (token != null) {
      // Delete from DB - Don't need to await
      ref.read(authRepositoryProvider).deleteSecret(token);
      // Delete from FCM - Don't need to await
      notifications.deleteToken();
    }
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
  }

  Future<bool> _initPermssions() async {
    final isPermittedAlready = await notifications.hasPermissions();
    if (!isPermittedAlready) {
      final isPermitted = await notifications.requestPermissions();
      if (!isPermitted) return false;
    }
    return true;
  }

  // Note: we are fetching token each time, not ideal, but it's free
  // And can't be certain old tokens are for this device and still active.
  Future<bool> _initTokens() async {
    final fcmToken = await notifications.getToken();
    if (fcmToken == null) return false;

    // Add Apple token if exists
    final apnsToken = await notifications.getAPNSToken();

    final token = Token(fcmValue: fcmToken, apnsValue: apnsToken);

    if (await _tokenNotSet(token)) _addToken(token);

    _tokenRefreshSubscription = notifications.onFCMTokenRefresh().listen(
          (fcmToken) => _addToken(Token(fcmValue: fcmToken)),
        );
    _tokenRefreshSubscription?.onError((err, st) async =>
        logger.error('_initTokens() onFCMTokenRefresh()', err, st));

    return true;
  }

  Future<bool> _tokenNotSet(Token token) async {
    final hasToken = await ref.read(authRepositoryProvider).hasToken(token);
    return !hasToken;
  }

  Future<void> _addToken(Token token) async {
    await ref.read(authRepositoryProvider).addFCMToken(token);
  }
}

@riverpod
NotificationService notificationService(NotificationServiceRef ref) {
  final notifications = ref.read(notificationsProvider);
  final notificationService =
      NotificationService(ref: ref, notifications: notifications);
  ref.onDispose(() => notificationService.dispose());
  return notificationService;
}

@riverpod
FutureOr<NotificationRepository> initializedNotifications(
    InitializedNotificationsRef ref) async {
  final notificationService = ref.watch(notificationServiceProvider);
  final notificationRepository = await notificationService.initialize();
  logger.t('initialized notifications');
  return notificationRepository;
}
