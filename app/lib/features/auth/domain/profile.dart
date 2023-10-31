// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// * Database (Supabase) Stores Auth User and Profile in seperate tables
// * Auth User (id, email, encrypted_password)
// * Profile User (id, username, avatar_url, etc...)
// * Profile id is linked to Auth User Id
// * --> so that means, we often use User or Profile to mean the same thing

class Profile {
  const Profile({
    required this.id,
    required this.email,
    required this.username,
    required this.avatarUrl,
    required this.bio,
    required this.birthdate,
  });

  final String id;
  final String? email;
  final String? username;
  final String? avatarUrl;
  final String? bio;
  final DateTime? birthdate;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'username': username,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'birthdate': birthdate?.millisecondsSinceEpoch,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      avatarUrl: map['avatarUrl'] != null ? map['avatarUrl'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      birthdate: map['birthdate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['birthdate'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source) as Map<String, dynamic>);
}
