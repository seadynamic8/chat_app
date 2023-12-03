import 'package:chat_app/features/auth/data/current_profile_provider.dart';
import 'package:chat_app/features/chat/application/translation_service.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat_lobby/data/chat_lobby_repository.dart';
import 'package:chat_app/features/chat_lobby/domain/chat_lobby_item_state.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_lobby_item_controller.g.dart';

@riverpod
class ChatLobbyItemController extends _$ChatLobbyItemController {
  @override
  FutureOr<ChatLobbyItemState> build(String roomId) async {
    final currentProfileId = ref.watch(currentProfileProvider).id!;
    final chatLobbyItemState = await ref
        .watch(chatLobbyRepositoryProvider)
        .getChatLobbyItemState(roomId, currentProfileId);

    ref.listen<AsyncValue<Message>>(newMessagesStreamProvider(roomId),
        (_, state) {
      if (state.hasValue) _setNewestMessage(state.value!);
    });

    return chatLobbyItemState;
  }

  void _setNewestMessage(Message message) async {
    // Set newest message first
    final oldState = await future;
    state = AsyncData(oldState.copyWith(newestMessage: message));

    // Then fetch translation and save
    final currentProfileId = ref.watch(currentProfileProvider).id!;
    if (message.profileId != currentProfileId) {
      _updateNewestMessageTranslation(message);
    }
  }

  void _updateNewestMessageTranslation(Message message) async {
    final oldState = await future;

    final translatedText = await ref
        .read(translationServiceProvider)
        .getTranslation(oldState.otherProfile.language!, message.content);

    if (translatedText == null) return;

    // Update the message with translation
    state = AsyncData(
      oldState.copyWith(
        newestMessage:
            oldState.newestMessage!.copyWith(translation: translatedText),
      ),
    );

    ref
        .read(chatRepositoryProvider)
        .saveTranslationForMessage(message.id!, translatedText);
  }
}