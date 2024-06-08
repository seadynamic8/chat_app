import 'package:another_flushbar/flushbar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/home/data/notification_repository.dart';
import 'package:chat_app/features/home/domain/notification_message.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';

extension NotificationSnackBarExtension on BuildContext {
  void onBackgroundNotificationClicked(
      NotificationType type, NotificationMessage? message) {
    if (message == null) return;
    if (message.notificationExists) {
      logger.t('[ Notification clicked ] (${type.name}) : ${message.title!}');
      _goToChatRoom(message);
    }
  }

  void showAppNotification(NotificationMessage? message) async {
    if (message == null) return;
    if (message.notificationExists) {
      logger.t(
          '[ Notification received ] (${NotificationType.foreground.name}) : ${message.title!}');
      if (_showOnCurrentRoute()) {
        showNotificationBar(
          message.title!,
          message.body!,
          () => _goToChatRoom(message),
        );
        FlutterRingtonePlayer().playNotification();
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate();
        }
      }
    }
  }

  void showNotificationBar(String title, String content, [Function? onTap]) {
    final theme = Theme.of(this);
    if (!mounted) return;
    Flushbar(
      title: title,
      message: content,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      duration: const Duration(milliseconds: 3000),
      reverseAnimationCurve: Curves.easeIn,
      forwardAnimationCurve: Curves.easeInOut,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      borderRadius: BorderRadius.circular(5),
      boxShadows: const [
        BoxShadow(
            color: Colors.black54, offset: Offset(0, 2.0), blurRadius: 5.0)
      ],
      backgroundColor: theme.colorScheme.primary.withAlpha(230),
      titleColor: theme.colorScheme.onPrimary,
      messageColor: theme.colorScheme.onPrimary,
      titleSize: theme.textTheme.labelLarge!.fontSize,
      margin: const EdgeInsets.only(
        top: 40,
        left: 20,
        right: 20,
      ),
      onTap: onTap == null ? null : (_) => onTap(),
    ).show(this);
  }

  bool _showOnCurrentRoute() {
    final currentRoute = router.current.name;
    final routesNotShow = [
      ChatRoomRoute.name,
      WaitingRoute.name,
      VideoRoomRoute.name,
    ];
    return !routesNotShow.contains(currentRoute);
  }

  void _goToChatRoom(NotificationMessage message) {
    router.push(ChatRoomRoute(
      roomId: message.data['chatRoomId'],
      otherProfileId: message.data['profileId'],
    ));
  }
}
