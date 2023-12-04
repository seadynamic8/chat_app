import 'package:chat_app/common/pagination_state.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/data/current_profile_provider.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/application/translation_service.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/domain/message.dart';
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
  FutureOr<PaginationState<Message>> build(
      String roomId, Map<String, Profile> profiles) async {
    // Setup handlers for any new messages
    ref.listen<AsyncValue<Message>>(newMessagesStreamProvider(roomId),
        (_, state) {
      if (state.hasValue) _handleNewMessage(state.value!);
    });

    final chatRepository = ref.watch(chatRepositoryProvider);

    final messages = await chatRepository.getAllMessagesForRoom(
        roomId, initialPage, numberOfMessagesPerRequest + initialExtraMessages);

    final currentProfileId = ref.read(currentProfileProvider).id!;
    await chatRepository.markAllMessagesAsReadForRoom(roomId, currentProfileId);

    return PaginationState(nextPage: initialPage + 1, items: messages);
  }

  void getNextPageOfMessages() async {
    final oldState = await future;

    if (oldState.isLastPage) return;

    final newMessages = await ref
        .watch(chatRepositoryProvider)
        .getAllMessagesForRoom(
            roomId, oldState.nextPage, numberOfMessagesPerRequest);

    final isLastPage = newMessages.length < numberOfMessagesPerRequest;
    state = AsyncData(oldState.copyWith(
      isLastPage: isLastPage,
      nextPage: oldState.nextPage + 1,
      items: [...oldState.items, ...newMessages],
    ));
  }

  void _handleNewMessage(Message newMessage) async {
    // Add new message first
    final oldState = await future;
    state = AsyncData(
      oldState.copyWith(
        items: [newMessage, ...oldState.items],
      ),
    );

    final currentUserId = ref.read(authRepositoryProvider).currentUserId!;
    if (newMessage.profileId != currentUserId) {
      ref.read(chatRepositoryProvider).markMessageAsRead(newMessage.id!);

      _updateNewMessageTranslation(newMessage);
    }
  }

  void _updateNewMessageTranslation(Message newMessage) async {
    final translatedText = await ref
        .read(translationServiceProvider)
        .getTranslation(
            profiles[newMessage.profileId]!.language!, newMessage.content);

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
