import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/data/notification_repository.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service.g.dart';

class NotificationService {
  NotificationService({required this.ref});

  final Ref ref;

  Future<NotificationRepository> initialize() async {
    final notifications = ref.read(notificationsProvider);

    final isPermitted = await _initPermssions(notifications);
    if (!isPermitted) return notifications;

    final tokensInitialized = await _initTokens(notifications);
    if (!tokensInitialized) return notifications;

    await notifications.setupIOSNotifications();

    return notifications;
  }

  Future<bool> _initPermssions(NotificationRepository notifications) async {
    final isPermittedAlready = await notifications.hasPermissions();
    if (!isPermittedAlready) {
      final isPermitted = await notifications.requestPermissions();
      if (!isPermitted) return false;
    }
    return true;
  }

  // Note: we are fetching token each time, not ideal, but it's free
  // And can't be certain old tokens are for this device and still active.
  Future<bool> _initTokens(NotificationRepository notifications) async {
    final fcmToken = await notifications.getToken();
    if (fcmToken == null) return false;

    if (await _tokenNotSet(fcmToken)) _setFCMToken(fcmToken);

    notifications.onTokenRefresh().listen(_setFCMToken);

    return true;
  }

  Future<bool> _tokenNotSet(String fcmToken) async {
    final existingFCMTokens =
        await ref.read(authRepositoryProvider).getFCMTokens();
    return !existingFCMTokens.contains(fcmToken);
  }

  Future<void> _setFCMToken(String? fcmToken) async {
    if (fcmToken == null) {
      await logErrorMessage('Error getting FCM Token');
      return;
    }
    await ref.read(authRepositoryProvider).addFCMToken(fcmToken);
  }
}

@riverpod
NotificationService notificationService(NotificationServiceRef ref) {
  return NotificationService(ref: ref);
}

@riverpod
FutureOr<NotificationRepository> initializedNotifications(
    InitializedNotificationsRef ref) async {
  final notificationService = ref.watch(notificationServiceProvider);
  final notificationRepository = await notificationService.initialize();
  logger.t('initialized notifications');
  return notificationRepository;
}
