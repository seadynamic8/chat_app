import 'package:age_calculator/age_calculator.dart';
import 'package:chat_app/utils/locale_from_string.dart';
import 'package:flutter/material.dart';

// * Database (Supabase) Stores Auth User and Profile in seperate tables
// * Auth User (id, email, encrypted_password)
// * Profile User (id, username, avatar_url, etc...)
// * Profile id is linked to Auth User Id
// * --> so that means, we often use User or Profile to mean the same thing

enum Gender {
  male(Icons.male),
  female(Icons.female),
  other(Icons.transgender);

  final IconData icon;

  const Gender(this.icon);
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
    this.language,
    this.country,
    this.onlineAt,
  });

  final String? id;
  final String? email;
  final String? username;
  final String? avatarUrl;
  final String? bio;
  final DateTime? birthdate;
  final Gender? gender;
  final Locale? language;
  final String? country;
  final DateTime? onlineAt;

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
      'language': language?.toString(),
      'country': country,
      'online_at': onlineAt?.toIso8601String(),
    }..removeWhere((key, value) => value == null);
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
      language: map['language'] != null
          ? (map['language'] as String).getLocale()
          : null,
      country: map['country'] != null ? map['country'] as String : null,
      onlineAt: map['online_at'] != null
          ? DateTime.parse(map['online_at'] as String)
          : null,
    );
  }

  Profile copyWith({
    String? id,
    String? email,
    String? username,
    String? avatarUrl,
    String? bio,
    DateTime? birthdate,
    Gender? gender,
    Locale? language,
    String? country,
    DateTime? onlineAt,
  }) {
    return Profile(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      language: language ?? this.language,
      country: country ?? this.country,
      onlineAt: onlineAt ?? this.onlineAt,
    );
  }

  @override
  String toString() {
    return 'Profile(id: $id, email: $email, username: $username, avatarUrl: $avatarUrl, bio: $bio, birthdate: $birthdate, gender: $gender, language: $language, country: $country, onlineAt: $onlineAt)';
  }
}
