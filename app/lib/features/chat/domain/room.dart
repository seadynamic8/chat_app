import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/domain/message.dart';

class Room {
  Room({
    required this.id,
    required this.otherProfile,
    this.newestMessage,
  });

  final String id;
  final Profile? otherProfile;
  final Message? newestMessage;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'otherProfile': otherProfile?.toMap(),
      'newestMessage': newestMessage?.toMap(),
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] as String,
      otherProfile: map['profiles'] != null
          ? Profile.fromMap(map['profiles'].first as Map<String, dynamic>)
          : null,
      newestMessage: map['messages'] != null && map['messages'].isNotEmpty
          ? Message.fromMap(map['messages'].first as Map<String, dynamic>)
          : null,
    );
  }

  Room copyWith({
    String? id,
    Profile? otherProfile,
    Message? newestMessage,
  }) {
    return Room(
      id: id ?? this.id,
      otherProfile: otherProfile ?? this.otherProfile,
      newestMessage: newestMessage ?? this.newestMessage,
    );
  }

  @override
  String toString() =>
      'Room(id: $id, otherProfile: $otherProfile, newestMessage: $newestMessage)';
}
