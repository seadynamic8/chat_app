import 'package:chat_app/features/chat/domain/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'swiped_message_provider.g.dart';

@riverpod
class SwipedMessage extends _$SwipedMessage {
  @override
  Message? build() {
    return null;
  }

  void set(Message swipedMessage) {
    state = swipedMessage;
  }

  void cancel() {
    state = null;
  }
}
