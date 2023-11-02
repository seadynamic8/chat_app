import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/data/translate_repository.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_messages_controller.g.dart';

@riverpod
class ChatMessagesController extends _$ChatMessagesController {
  static const numberOfMessagesPerRequest = 10;

  @override
  PagingController<int, Message> build(String roomId) {
    final chatRepository = ref.watch(chatRepositoryProvider);
    chatRepository.watchNewMessageForRoom(roomId, _handleNewMessage);

    const firstPage = 0; // Our paging algorithm starts at 0

    final PagingController<int, Message> pagingController =
        PagingController(firstPageKey: firstPage);

    pagingController.addPageRequestListener((pageKey) async {
      final messages = await chatRepository.getAllMessagesForRoom(
          roomId, pageKey, numberOfMessagesPerRequest);

      final isLastPage = messages.length < numberOfMessagesPerRequest;

      if (isLastPage) {
        pagingController.appendLastPage(messages);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(messages, nextPageKey);
      }
    });

    return pagingController;
  }

  void _handleNewMessage(Map<String, dynamic> payload) async {
    final newMessage = Message.fromMap(payload['new']);

    // Add new message first
    if (state.itemList == null) {
      state.itemList = [newMessage];
    } else {
      state.itemList = [newMessage, ...state.itemList!];
    }

    // Then fetch translation and save
    final currentUserId = ref.read(authRepositoryProvider).currentUserId!;
    // TODO: Also check if both users locale are the same, then don't translate
    if (newMessage.profileId != currentUserId) {
      _updateNewMessageTranslation(newMessage);
    }
  }

  void _updateNewMessageTranslation(Message message) async {
    final translatedText = await _getTranslation(message.content);
    if (translatedText == null) return;

    final newList = [...state.itemList!];
    final messageIndex = newList.indexWhere((m) => m.id == message.id);
    newList[messageIndex] =
        newList[messageIndex].copyWith(translation: translatedText);
    state.itemList = newList;

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
