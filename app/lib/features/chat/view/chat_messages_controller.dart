import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/application/translation_service.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_messages_controller.g.dart';

@riverpod
class ChatMessagesController extends _$ChatMessagesController {
  static const numberOfMessagesPerRequest = 10;

  @override
  PagingController<int, Message> build(
      String roomId, Map<String, Profile> profiles) {
    // Setup handlers for any new messages
    ref
        .watch(chatRepositoryProvider)
        .watchNewMessageForRoom(roomId, _handleNewMessage);

    // Setup paging controller
    final PagingController<int, Message> pagingController =
        PagingController(firstPageKey: 0); // Our paging algorithm starts at 0

    pagingController.addPageRequestListener(_handlePageRequest);

    return pagingController;
  }

  void _handlePageRequest(int pageKey) async {
    final messages = await ref
        .watch(chatRepositoryProvider)
        .getAllMessagesForRoom(roomId, pageKey, numberOfMessagesPerRequest);

    final isLastPage = messages.length < numberOfMessagesPerRequest;
    if (isLastPage) {
      state.appendLastPage(messages);
    } else {
      final nextPageKey = pageKey + 1;
      state.appendPage(messages, nextPageKey);
    }
  }

  void _handleNewMessage(Map<String, dynamic> payload) async {
    final newMessage = Message.fromMap(payload['new']);

    // Add new message first
    state.itemList = state.itemList == null
        ? [newMessage]
        : [newMessage, ...state.itemList!];

    // Then fetch translation and save
    final currentUserId = ref.read(authRepositoryProvider).currentUserId!;
    if (newMessage.profileId != currentUserId) {
      _updateNewMessageTranslation(newMessage);
    }
  }

  void _updateNewMessageTranslation(Message message) async {
    final translatedText = await ref
        .read(translationServiceProvider)
        .getTranslation(
            profiles[message.profileId]!.language!, message.content);

    if (translatedText == null) return;

    // Update the message with translation
    final newList = [...state.itemList!];
    final messageIndex = newList.indexWhere((m) => m.id == message.id);
    newList[messageIndex] =
        newList[messageIndex].copyWith(translation: translatedText);
    state.itemList = newList;

    ref
        .read(chatRepositoryProvider)
        .saveTranslationForMessage(message.id!, translatedText);
  }
}
