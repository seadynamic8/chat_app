import 'package:chat_app/common/pagination_state.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat/application/chat_service.dart';
import 'package:chat_app/features/chat/application/translation_service.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
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
  FutureOr<PaginationState<Message>> build(String roomId) async {
    final chatService = ref.read(chatServiceProvider);

    // Mark all messages as read first
    await chatService.markAllMessagesAsRead(roomId);

    // Get messages for room
    final (messages, _) = await chatService.getMessagesForRoom(
      roomId: roomId,
      page: initialPage,
      range: numberOfMessagesPerRequest + initialExtraMessages,
      maxMessages: numberOfMessagesPerRequest,
    );

    // Setup handlers for any new messages
    ref.listen<AsyncValue<Message>>(newMessagesStreamProvider(roomId),
        (_, state) {
      if (state.hasValue) _handleNewMessage(state.value!);
    });

    return PaginationState<Message>(
      nextPage: initialPage + 1,
      items: messages,
    );
  }

  void getNextPageOfMessages() async {
    final oldState = await future;

    if (oldState.isLastPage) return;

    final (newMessages, isLastPage) =
        await ref.read(chatServiceProvider).getMessagesForRoom(
              roomId: roomId,
              page: oldState.nextPage!,
              range: numberOfMessagesPerRequest,
              maxMessages: numberOfMessagesPerRequest,
              lastMessage: oldState.items.last,
            );

    state = AsyncData(oldState.copyWith(
      isLastPage: isLastPage,
      nextPage: oldState.nextPage! + 1,
      items: [...oldState.items, ...newMessages],
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
    final otherProfile =
        await ref.read(profileStreamProvider(newMessage.profileId!).future);
    final translatedText = await ref
        .read(translationServiceProvider)
        .getTranslation(otherProfile.language!, newMessage.content!);

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
}
