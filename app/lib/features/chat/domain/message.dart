// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/i18n/localizations.dart';

class Message {
  Message({
    this.id,
    this.type,
    required this.content,
    this.translation,
    required this.profileId,
    this.createdAt,
  });

  final String? id;
  final String? type;
  final String content;
  final String? translation;
  final String profileId;
  final DateTime? createdAt;

  bool missed(bool isCurrentUser) =>
      _getVideoContent(isCurrentUser) == 'missed';

  String videoLabel(bool isCurrentUser) {
    final videoContent = _getVideoContent(isCurrentUser);

    if (videoContent == 'missed') {
      return 'Missed video call'.i18n;
    }
    return 'Video call '.i18n + videoContent;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'content': content,
      'translation': translation,
      'profileId': profileId,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] != null ? map['id'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
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
    String? type,
    String? content,
    String? translation,
    String? profileId,
    DateTime? createdAt,
  }) {
    return Message(
      id: id ?? this.id,
      type: type ?? this.type,
      content: content ?? this.content,
      translation: translation ?? this.translation,
      profileId: profileId ?? this.profileId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, type: $type, content: $content, translation: $translation, profileId: $profileId, createdAt: $createdAt)';
  }

  // Friendly video status
  String _getVideoContent(bool isCurrentUser) {
    if (type == 'video') {
      if (content == 'rejected') return 'ended'.i18n;

      if (content == 'cancelled' && !isCurrentUser) return 'missed'.i18n;
    }
    return content;
  }
}
