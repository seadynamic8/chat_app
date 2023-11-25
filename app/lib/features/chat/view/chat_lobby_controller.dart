import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/application/translation_service.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat/domain/room.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_lobby_controller.g.dart';

@riverpod
class ChatLobbyController extends _$ChatLobbyController {
  @override
  FutureOr<List<Room>> build() async {
    final currentUserId = ref.watch(authRepositoryProvider).currentUserId!;
    final chatRepository = ref.watch(chatRepositoryProvider);

    final allRooms = await chatRepository.getAllRoomsByUser(currentUserId);

    chatRepository.watchNewRoomForUser(currentUserId, _addNewRoom);

    // Watch for updates to the newestMessages for each room
    for (final room in allRooms) {
      ref.listen<AsyncValue<Message>>(watchNewMessagesStreamProvider(room.id),
          (_, state) {
        if (state.hasValue) _setNewestMessage(room, state.value!);
      });
    }
    return allRooms;
  }

  void _addNewRoom(Room newRoom) async {
    final oldState = await future;
    state = AsyncData([...oldState, newRoom]);
  }

  void _setNewestMessage(Room room, Message message) async {
    final oldState = await future;

    // Set newest message first
    final roomIndex = oldState.indexWhere((r) => r.id == room.id);
    oldState[roomIndex] = oldState[roomIndex].copyWith(newestMessage: message);

    state = AsyncData(oldState);

    // Then fetch translation and save
    final currentUserId = ref.read(authRepositoryProvider).currentUserId!;
    if (message.profileId != currentUserId) {
      _updateNewestMessageTranslation(room.otherProfile!, message);
    }
  }

  void _updateNewestMessageTranslation(
    Profile otherProfile,
    Message message,
  ) async {
    final translatedText = await ref
        .read(translationServiceProvider)
        .getTranslation(otherProfile.language!, message.content);

    if (translatedText == null) return;

    // Update the message with translation
    final oldState = await future;
    state = AsyncData(oldState.map(
      (room) {
        if (room.newestMessage!.id == message.id) {
          return room.copyWith(
            newestMessage:
                room.newestMessage!.copyWith(translation: translatedText),
          );
        }
        return room;
      },
    ).toList());

    ref
        .read(chatRepositoryProvider)
        .saveTranslationForMessage(message.id!, translatedText);
  }
}
