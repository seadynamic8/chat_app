import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/data/translate_repository.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_messages_controller.g.dart';

@riverpod
class ChatMessagesController extends _$ChatMessagesController {
  @override
  Future<List<Message>> build(String roomId) async {
    final chatRepository = ref.watch(chatRepositoryProvider);
    chatRepository.watchNewMessageForRoom(roomId, _handleNewMessage);

    return await chatRepository.getAllMessagesForRoom(roomId);
  }

  void _handleNewMessage(Map<String, dynamic> payload) async {
    final newMessage = Message.fromMap(payload['new']);

    // Add new message first
    final old = await future;
    state = AsyncData([newMessage, ...old]);

    final currentUserId = ref.read(authRepositoryProvider).currentUserId!;
    // TODO: Also check if both users locale are the same, then don't translate
    if (newMessage.profileId != currentUserId) {
      _updateNewMessageTranslation(newMessage);
    }
  }

  void _updateNewMessageTranslation(Message message) async {
    final translatedText = await _getTranslation(message.content);

    if (translatedText == null) return;

    var old = await future;
    final messageIndex = old.indexWhere((m) => m.id == message.id);
    old[messageIndex] = old[messageIndex].copyWith(translation: translatedText);
    state = AsyncData([...old]);

    _saveTranslation(message, translatedText);
  }

  Future<String?> _getTranslation(String messageText) async {
    final translateRepository = ref.read(translateRepositoryProvider);

    // TODO: Need to update this to update this  to use user profile locale
    // final languageCode = I18n.language; // Current locale
    // also, if message locale is the same as (user's locale), then return
    const languageCode = 'es'; // For testing, use Spanish

    return await translateRepository.translate(
        text: messageText, toLangCode: languageCode);
  }

  void _saveTranslation(Message message, String translation) {
    ref
        .read(chatRepositoryProvider)
        .saveTranslationForMessage(message.id!, translation);
  }
}
