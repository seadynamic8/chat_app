// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/features/auth/domain/profile.dart';

class ChatRoom {
  ChatRoom({
    required this.id,
    required this.profiles,
    required this.joined,
  });

  final String id;
  final Map<String, Profile> profiles;
  final bool joined;

  ChatRoom copyWith({
    String? id,
    Map<String, Profile>? profiles,
    bool? joined,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      profiles: profiles ?? this.profiles,
      joined: joined ?? this.joined,
    );
  }
}
