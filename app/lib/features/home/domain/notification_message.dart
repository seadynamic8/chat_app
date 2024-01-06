import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationMessage {
  NotificationMessage({required this.message});

  final RemoteMessage message;

  bool get notificationExists => message.notification != null;

  String? get title => message.notification?.title;
  String? get body => message.notification?.body;
  Map<String, dynamic> get data => message.data;
}
