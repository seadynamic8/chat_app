import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_messages_controller.g.dart';

@riverpod
class ChatMessagesController extends _$ChatMessagesController {
  @override
  Future<List<Message>> build(String roomId) async {
    final chatRepository = ref.watch(chatRepositoryProvider);

    chatRepository.watchNewMessageForRoom(roomId, _handleNewMessage);

    final messages = await chatRepository.getAllMessagesForRoom(roomId);

    return messages;
  }

  void _handleNewMessage(Map<String, dynamic> payload) async {
    final old = await future;

    final newMessage = Message.fromMap(payload['new']);

    state = AsyncData([newMessage, ...old]);
  }
}
