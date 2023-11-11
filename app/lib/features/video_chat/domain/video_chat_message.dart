// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:videosdk/videosdk.dart';

class VideoChatMessage {
  VideoChatMessage({required this.psMessage, this.translation});

  final PubSubMessage psMessage;

  final String? translation;

  String get id => psMessage.id;
  String get content => psMessage.message;
  String get senderId => psMessage.senderId;
  String get senderUserName => psMessage.senderName;
  DateTime get createdAt => psMessage.timestamp;
  String get topic => psMessage.topic;
  Map<String, dynamic>? get payload => psMessage.payload;

  VideoChatMessage copyWith({
    PubSubMessage? psMessage,
    String? translation,
  }) {
    return VideoChatMessage(
      psMessage: psMessage ?? this.psMessage,
      translation: translation ?? this.translation,
    );
  }
}
