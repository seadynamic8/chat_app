class Message {
  Message({required this.content, required this.profileId});

  final String content;
  final String profileId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'profile_id': profileId,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      content: map['content'] as String,
      profileId: map['profile_id'] as String,
    );
  }
}
