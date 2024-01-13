import 'package:chat_app/common/pagination_state.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat/application/translation_service.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/domain/chat_room.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/utils/new_day_extension.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_messages_controller.g.dart';

@riverpod
class ChatMessagesController extends _$ChatMessagesController {
  // Make sure this fills the screen or it won't even scroll.
  // Also don't make too small since you don't want to query the API too much.
  static const initialExtraMessages = 10;
  static const numberOfMessagesPerRequest = 20;
  static const initialPage = 0;

  @override
  FutureOr<PaginationState<Message>> build(ChatRoom chatRoom) async {
    // Setup handlers for any new messages
    ref.listen<AsyncValue<Message>>(newMessagesStreamProvider(chatRoom.id),
        (_, state) {
      if (state.hasValue) _handleNewMessage(state.value!);
    });

    final chatRepository = ref.watch(chatRepositoryProvider);

    final messages = await chatRepository.getAllMessagesForRoom(chatRoom.id,
        initialPage, numberOfMessagesPerRequest + initialExtraMessages);

    final updatedMessages = _addNewDayToMessages(null, messages);

    final currentProfileId = ref.read(currentUserIdProvider)!;

    await chatRepository.markAllMessagesAsReadForRoom(
        chatRoom.id, currentProfileId);

    return PaginationState<Message>(
      nextPage: initialPage + 1,
      items: updatedMessages,
    );
  }

  void getNextPageOfMessages() async {
    final oldState = await future;

    if (oldState.isLastPage) return;

    final newMessages = await ref
        .watch(chatRepositoryProvider)
        .getAllMessagesForRoom(
            chatRoom.id, oldState.nextPage!, numberOfMessagesPerRequest);

    final isLastPage = newMessages.length < numberOfMessagesPerRequest;

    final updatedMessages =
        _addNewDayToMessages(oldState.items.last, newMessages);

    state = AsyncData(oldState.copyWith(
      isLastPage: isLastPage,
      nextPage: oldState.nextPage! + 1,
      items: [...oldState.items, ...updatedMessages],
    ));
  }

  void _handleNewMessage(Message newMessage) async {
    final oldState = await future;

    final updatedNewMessages = [newMessage];

    if (oldState.items.isNotEmpty &&
        newMessage.createdAt != null &&
        newMessage.createdAt!.isNewDayAfter(oldState.items.first.createdAt)) {
      updatedNewMessages.add(Message.newDay(newMessage));
    }

    state = AsyncData(oldState.copyWith(
      items: [...updatedNewMessages, ...oldState.items],
    ));

    final currentUserId = ref.read(currentUserIdProvider)!;
    if (!newMessage.isCurrentUser(currentUserId)) {
      ref.read(chatRepositoryProvider).markMessageAsRead(newMessage.id!);

      _updateNewMessageTranslation(newMessage);
    }
  }

  void _updateNewMessageTranslation(Message newMessage) async {
    final translatedText = await ref
        .read(translationServiceProvider)
        .getTranslation(chatRoom.profiles[newMessage.profileId]!.language!,
            newMessage.content);

    if (translatedText == null) return;

    // Update the message with translation
    final oldState = await future;
    final newMessages = oldState.items.map((oldMessage) {
      if (oldMessage.id == newMessage.id) {
        return oldMessage.copyWith(translation: translatedText);
      }
      return oldMessage;
    }).toList();
    state = AsyncData(oldState.copyWith(items: newMessages));

    ref
        .read(chatRepositoryProvider)
        .saveTranslationForMessage(newMessage.id!, translatedText);
  }

  // - Handle 2 situations:
  //  - New build with existing messages (no prev message - null)
  //  - getNextPageOfMessages, it needs the last message from the last page.
  List<Message> _addNewDayToMessages(
      Message? prevMessage, List<Message> messages) {
    List<Message> updatedMessages = [];
    // Can be null, also never should add to updated list since it's used only
    //for checking dates, so not inside loop.
    var prev = prevMessage;

    for (final message in messages) {
      if (prev != null && prev.createdAt!.isNewDayAfter(message.createdAt!)) {
        updatedMessages.add(Message.newDay(prev));
      }
      // Always add the current message
      updatedMessages.add(message);

      // Update prev to current message
      prev = message;
    }
    return updatedMessages;
  }
}
