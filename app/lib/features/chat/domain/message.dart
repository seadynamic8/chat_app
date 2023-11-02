// ignore_for_file: public_member_api_docs, sort_constructors_first
class Message {
  Message({
    this.id,
    required this.content,
    this.translation,
    required this.profileId,
  });

  String? id;
  final String content;
  String? translation;
  final String profileId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'translation': translation,
      'profile_id': profileId,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] != null ? map['id'] as String : null,
      content: map['content'] as String,
      translation:
          map['translation'] != null ? map['translation'] as String : null,
      profileId: map['profile_id'] as String,
    );
  }

  Message copyWith({
    String? id,
    String? content,
    String? translation,
    String? profileId,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      translation: translation ?? this.translation,
      profileId: profileId ?? this.profileId,
    );
  }
}
