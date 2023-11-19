import 'package:chat_app/features/auth/data/auth_repository.dart';
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
        if (state.hasValue) _setNewestMessage(room.id, state.value!);
      });
    }
    return allRooms;
  }

  void _addNewRoom(Room newRoom) async {
    final oldState = await future;
    state = AsyncData([...oldState, newRoom]);
  }

  void _setNewestMessage(String roomId, Message message) async {
    final oldState = await future;

    final roomIndex = oldState.indexWhere((room) => room.id == roomId);
    oldState[roomIndex] = oldState[roomIndex].copyWith(newestMessage: message);

    state = AsyncData(oldState);
  }
}
