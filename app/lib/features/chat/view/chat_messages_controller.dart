import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/application/translation_service.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/domain/chat_messages_state.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_messages_controller.g.dart';

@riverpod
class ChatMessagesController extends _$ChatMessagesController {
  // Make sure this fills the screen or it won't even scroll.
  // Also don't make too small since you don't want to query the API too much.
  static const numberOfMessagesPerRequest = 20;
  static const initialPage = 0;

  @override
  FutureOr<ChatMessagesState> build(
      String roomId, Map<String, Profile> profiles) async {
    // Setup handlers for any new messages
    ref.listen<AsyncValue<Message>>(watchNewMessagesStreamProvider(roomId),
        (_, state) {
      if (state.hasValue) _handleNewMessage(state.value!);
    });

    // Add 10 to initial request to fill the page
    // subsequent requests will be smaller
    final messages = await ref
        .watch(chatRepositoryProvider)
        .getAllMessagesForRoom(
            roomId, initialPage, numberOfMessagesPerRequest + 10);

    return ChatMessagesState(nextPage: initialPage + 1, messages: messages);
  }

  void getNextPageOfMessages() async {
    final oldState = await future;

    final newMessages = await ref
        .watch(chatRepositoryProvider)
        .getAllMessagesForRoom(
            roomId, oldState.nextPage, numberOfMessagesPerRequest);

    final isLastPage = newMessages.length < numberOfMessagesPerRequest;
    state = AsyncData(oldState.copyWith(
      isLastPage: isLastPage,
      nextPage: oldState.nextPage + 1,
      messages: [...oldState.messages, ...newMessages],
    ));
  }

  void _handleNewMessage(Message newMessage) async {
    // Add new message first
    final oldState = await future;
    state = AsyncData(
      oldState.copyWith(
        messages: [newMessage, ...oldState.messages],
      ),
    );

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
    final oldState = await future;
    final messageIndex =
        oldState.messages.indexWhere((m) => m.id == message.id);
    oldState.messages[messageIndex] =
        oldState.messages[messageIndex].copyWith(translation: translatedText);
    state = AsyncData(oldState);

    ref
        .read(chatRepositoryProvider)
        .saveTranslationForMessage(message.id!, translatedText);
  }
}
