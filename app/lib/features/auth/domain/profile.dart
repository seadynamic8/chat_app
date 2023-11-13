// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:age_calculator/age_calculator.dart';

// * Database (Supabase) Stores Auth User and Profile in seperate tables
// * Auth User (id, email, encrypted_password)
// * Profile User (id, username, avatar_url, etc...)
// * Profile id is linked to Auth User Id
// * --> so that means, we often use User or Profile to mean the same thing

enum Gender {
  male,
  female,
}

class Profile {
  const Profile({
    this.id,
    this.email,
    this.username,
    this.avatarUrl,
    this.bio,
    this.birthdate,
    this.gender,
  });

  final String? id;
  final String? email;
  final String? username;
  final String? avatarUrl;
  final String? bio;
  final DateTime? birthdate;
  final Gender? gender;

  String? get age {
    if (birthdate == null) return null;
    return AgeCalculator.age(birthdate!).years.toString();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'username': username,
      'avatar_url': avatarUrl,
      'bio': bio,
      'birthdate': birthdate?.toIso8601String(),
      'gender': gender?.name,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] != null ? map['id'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      avatarUrl: map['avatar_url'] != null ? map['avatar_url'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      birthdate: map['birthdate'] != null
          ? DateTime.parse(map['birthdate'] as String)
          : null,
      gender: map['gender'] != null
          ? Gender.values.byName(map['gender'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source) as Map<String, dynamic>);

  Profile copyWith({
    String? id,
    String? email,
    String? username,
    String? avatarUrl,
    String? bio,
    DateTime? birthdate,
    Gender? gender,
  }) {
    return Profile(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
    );
  }

  Profile copyWithMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] ?? id,
      email: map['email'] ?? email,
      username: map['username'] ?? username,
      avatarUrl: map['avatarUrl'] ?? avatarUrl,
      bio: map['bio'] ?? bio,
      birthdate: map['birthdate'] ?? birthdate,
      gender: map['gender'] ?? gender,
    );
  }

  @override
  String toString() {
    return 'Profile(id: $id, email: $email, username: $username, avatarUrl: $avatarUrl, bio: $bio, birthdate: $birthdate, gender: $gender)';
  }
}
