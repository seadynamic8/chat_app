// ignore_for_file: public_member_api_docs, sort_constructors_first
class Message {
  Message({
    this.id,
    required this.content,
    this.translation,
    required this.profileId,
    this.createdAt,
  });

  final String? id;
  final String content;
  final String? translation;
  final String profileId;
  final DateTime? createdAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'translation': translation,
      'profileId': profileId,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] != null ? map['id'] as String : null,
      content: map['content'] as String,
      translation:
          map['translation'] != null ? map['translation'] as String : null,
      profileId: map['profile_id'] as String,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }

  Message copyWith({
    String? id,
    String? content,
    String? translation,
    String? profileId,
    DateTime? createdAt,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      translation: translation ?? this.translation,
      profileId: profileId ?? this.profileId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, content: $content, translation: $translation, profileId: $profileId, createdAt: $createdAt)';
  }
}
