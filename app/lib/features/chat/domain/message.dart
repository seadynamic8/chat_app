import 'package:chat_app/features/chat/view/chat_more_menu_controller.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:intl/intl.dart';

enum MessageType { video, block, newday, user }

class Message {
  Message({
    this.id,
    this.type,
    required this.content,
    this.translation,
    this.profileId,
    this.createdAt,
  });

  final String? id;
  final MessageType? type;
  final String content;
  final String? translation;
  final String? profileId;
  final DateTime? createdAt;

  static Message newDay(Message message) {
    return Message(content: message.newDayString, type: MessageType.newday);
  }

  bool missed(bool isCurrentUser) =>
      _getVideoContent(isCurrentUser) == 'missed';

  String videoLabel(bool isCurrentUser) {
    final videoContent = _getVideoContent(isCurrentUser);

    if (videoContent == 'missed') {
      return 'Missed video call'.i18n;
    }
    return 'Video call '.i18n + videoContent;
  }

  DateTime? get localCreatedAt {
    return createdAt?.toLocal();
  }

  String? get localTime {
    if (localCreatedAt == null) return null;
    return DateFormat('jm').format(localCreatedAt!);
  }

  String get newDayString {
    return '------ ${DateFormat.yMMMd().format(localCreatedAt!)} -----';
  }

  String blockAction({required bool isCurrentUser}) {
    final blockAction = ChatBlockAction.values.byName(content);
    return isCurrentUser
        ? 'You have ${blockAction.name}ed the other user'.i18n
        : 'The other user has ${blockAction.name}ed you'.i18n;
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
      type: map['type'] != null
          ? MessageType.values.byName(map['type'] as String)
          : null,
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
    MessageType? type,
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
    if (type == MessageType.video) {
      if (content == 'rejected') return 'ended'.i18n;

      if (content == 'cancelled' && !isCurrentUser) return 'missed'.i18n;
    }
    return content;
  }
}
