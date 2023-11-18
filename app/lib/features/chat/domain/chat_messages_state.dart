// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:chat_app/features/chat/domain/message.dart';

class ChatMessagesState {
  ChatMessagesState({
    this.isLastPage = false,
    required this.nextPage,
    required this.messages,
  });

  final bool isLastPage;
  final int nextPage;
  final List<Message> messages;

  @override
  String toString() =>
      'ChatMessagesState(isLastPage: $isLastPage, nextPage: $nextPage, messages: $messages)';

  @override
  bool operator ==(covariant ChatMessagesState other) {
    if (identical(this, other)) return true;

    return other.isLastPage == isLastPage &&
        other.nextPage == nextPage &&
        listEquals(other.messages, messages);
  }

  @override
  int get hashCode =>
      isLastPage.hashCode ^ nextPage.hashCode ^ messages.hashCode;

  ChatMessagesState copyWith({
    bool? isLastPage,
    int? nextPage,
    List<Message>? messages,
  }) {
    return ChatMessagesState(
      isLastPage: isLastPage ?? this.isLastPage,
      nextPage: nextPage ?? this.nextPage,
      messages: messages ?? this.messages,
    );
  }
}
