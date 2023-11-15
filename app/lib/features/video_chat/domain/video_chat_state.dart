// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/video_chat/domain/video_chat_message.dart';

class VideoChatState {
  VideoChatState({required this.messages, required this.profiles});

  final List<VideoChatMessage> messages;
  final Map<String, Profile> profiles;

  @override
  bool operator ==(covariant VideoChatState other) {
    if (identical(this, other)) return true;

    return listEquals(other.messages, messages) &&
        mapEquals(other.profiles, profiles);
  }

  @override
  int get hashCode => messages.hashCode ^ profiles.hashCode;

  @override
  String toString() =>
      'VideoChatState(messages: $messages, profiles: $profiles)';

  VideoChatState copyWith({
    List<VideoChatMessage>? messages,
    Map<String, Profile>? profiles,
  }) {
    return VideoChatState(
      messages: messages ?? this.messages,
      profiles: profiles ?? this.profiles,
    );
  }
}
