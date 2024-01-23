import 'package:chat_app/features/chat/view/chat_more_menu_controller.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:intl/intl.dart';

enum MessageType { video, block, newday, user }

class Message {
  const Message({
    this.id,
    this.type,
    this.content,
    this.translation,
    this.profileId,
    this.roomId,
    this.createdAt,
    this.read,
    this.replyMessage,
  });

  final String? id;
  final MessageType? type;
  final String? content;
  final String? translation;
  final String? profileId;
  final String? roomId;
  final DateTime? createdAt;
  final bool? read;
  final Message? replyMessage;

  bool isCurrentUser(String currentUserId) {
    return profileId == currentUserId;
  }

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
    final blockAction = ChatBlockAction.values.byName(content!);
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
      'profile_id': profileId,
      'room_id': roomId,
      'created_at': createdAt?.toIso8601String(),
      'read': read,
      'parent_message_id': replyMessage?.id,
    }..removeWhere((key, value) => value == null);
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] != null ? map['id'] as String : null,
      type: map['type'] != null
          ? MessageType.values.byName(map['type'] as String)
          : null,
      content: map['content'] != null ? map['content'] as String : null,
      translation:
          map['translation'] != null ? map['translation'] as String : null,
      profileId: map['profile_id'] != null ? map['profile_id'] as String : null,
      roomId: map['room_id'] != null ? map['room_id'] as String : null,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      read: map['read'] != null ? map['read'] as bool : null,
      replyMessage: map['reply_message'] != null
          ? Message.fromMap(map['reply_message'] as Map<String, dynamic>)
          : null,
    );
  }

  Message copyWith({
    String? id,
    MessageType? type,
    String? content,
    String? translation,
    String? profileId,
    String? roomId,
    DateTime? createdAt,
    bool? read,
    Message? replyMessage,
  }) {
    return Message(
      id: id ?? this.id,
      type: type ?? this.type,
      content: content ?? this.content,
      translation: translation ?? this.translation,
      profileId: profileId ?? this.profileId,
      roomId: roomId ?? this.roomId,
      createdAt: createdAt ?? this.createdAt,
      read: read ?? this.read,
      replyMessage: replyMessage ?? this.replyMessage,
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, type: $type, content: $content, translation: $translation, profileId: $profileId, roomId: $roomId, createdAt: $createdAt, read: $read, replyMessage: $replyMessage)';
  }

  // Friendly video status
  String _getVideoContent(bool isCurrentUser) {
    if (type == MessageType.video) {
      if (content == 'rejected') return 'ended'.i18n;

      if (content == 'cancelled' && !isCurrentUser) return 'missed'.i18n;
    }
    return content!;
  }
}
