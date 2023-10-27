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
  final String email;
  final String? username;
  final String? avatarUrl;
  final String? bio;
  final DateTime birthdate;
}
