import 'package:chat_app/features/home/domain/notification_message.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_repository.g.dart';

enum NotificationType { terminated, background, foreground, data }

// Needs to be top-level (global) function, outside any class to work
// @pragma('vm:entry-point')
// Future<void> handleBackgroundMessage(RemoteMessage message) async {
// }

class NotificationRepository {
  NotificationRepository({required this.ref});

  final Ref ref;
  final messaging = FirebaseMessaging.instance;

  // Note: for permissions, we assume 'provisional' status as not permitted (iOS)

  Future<bool> hasPermissions() async {
    try {
      final settings = await messaging.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    } catch (error, st) {
      await logError('hasPermissions()', error, st);
      return false;
    }
  }

  Future<bool> requestPermissions() async {
    try {
      final permission = await messaging.requestPermission();
      return permission.authorizationStatus == AuthorizationStatus.authorized;
    } catch (error, st) {
      await logError('getPermissions()', error, st);
      return false;
    }
  }

  Future<String?> getToken() async {
    String? fcmToken;
    fcmToken = await messaging.getAPNSToken(); // Apple devices
    logger.i('apple token: $fcmToken');
    fcmToken ??= await messaging.getToken(); // Other than Apple devices
    logger.i('token: $fcmToken');
    return fcmToken;
  }

  Stream<String> onTokenRefresh() {
    return messaging.onTokenRefresh;
  }

  Future<void> setupIOSNotifications() async {
    // IOS foreground notification options
    await messaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
  }

  // App opened from terminated state (after message clicked)
  Future<NotificationMessage?> onInitialMessage() async {
    final message = await messaging.getInitialMessage();
    if (message == null) return null;
    return NotificationMessage(message: message);
  }

  Stream<NotificationMessage> watchClickedBackgroundMessages() {
    return FirebaseMessaging.onMessageOpenedApp
        .map((message) => NotificationMessage(message: message));
  }

  Stream<NotificationMessage> watchForegroundMessages() {
    return FirebaseMessaging.onMessage
        .map((message) => NotificationMessage(message: message));
  }
}

// * Make sure to initialize the notifcations first, with notificationService.initialize()
@riverpod
NotificationRepository notifications(NotificationsRef ref) {
  return NotificationRepository(ref: ref);
}

@riverpod
FutureOr<NotificationMessage?> initialMessage(InitialMessageRef ref) {
  final notificationRepository = ref.watch(notificationsProvider);
  return notificationRepository.onInitialMessage();
}

@riverpod
Stream<NotificationMessage> clickedBackgroundMessages(
    ClickedBackgroundMessagesRef ref) {
  final notificationRepository = ref.watch(notificationsProvider);
  return notificationRepository.watchClickedBackgroundMessages();
}

@riverpod
Stream<NotificationMessage> foregroundMessages(ForegroundMessagesRef ref) {
  final notificationRepository = ref.watch(notificationsProvider);
  return notificationRepository.watchForegroundMessages();
}
