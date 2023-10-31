import 'package:chat_app/features/auth/domain/profile.dart';

class Room {
  Room({required this.id, required this.otherProfile});

  final String id;
  final Profile? otherProfile;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'otherProfile': otherProfile?.toMap(),
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] as String,
      otherProfile: map['otherProfile'] != null
          ? Profile.fromMap(map['otherProfile'] as Map<String, dynamic>)
          : null,
    );
  }

  factory Room.fromMapWithCustomProfile(Map<String, dynamic> map) {
    return Room(
      id: map['id'] as String,
      otherProfile: Profile.fromMap(map['p2'].first as Map<String, dynamic>),
    );
  }
}
