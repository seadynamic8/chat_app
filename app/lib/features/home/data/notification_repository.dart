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
      logger.error('hasPermissions()', error, st);
      return false;
    }
  }

  Future<bool> requestPermissions() async {
    try {
      final permission = await messaging.requestPermission();
      return permission.authorizationStatus == AuthorizationStatus.authorized;
    } catch (error, st) {
      logger.error('getPermissions()', error, st);
      return false;
    }
  }

  Future<String?> getToken() async {
    final fcmToken = await messaging.getToken();
    return fcmToken;
  }

  // Apple devices
  Future<String?> getAPNSToken() async {
    final apnsToken = await messaging.getAPNSToken();
    return apnsToken;
  }

  Stream<String> onFCMTokenRefresh() {
    return messaging.onTokenRefresh;
  }

  Future<void> setupIOSNotifications() async {
    // IOS foreground notification options
    // alert - will make the foreground notification show
    // sound - would be nice, but we don't show foreground notification on all
    //         routes, and therefore, it would be weird if it makes sound then.
    await messaging.setForegroundNotificationPresentationOptions(
        alert: false, badge: false, sound: false);
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
