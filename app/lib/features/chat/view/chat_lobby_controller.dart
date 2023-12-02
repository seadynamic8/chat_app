import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/domain/room.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_lobby_controller.g.dart';

@riverpod
class ChatLobbyController extends _$ChatLobbyController {
  @override
  FutureOr<List<Room>> build() async {
    final currentUserId = ref.watch(authRepositoryProvider).currentUserId!;
    final chatRepository = ref.watch(chatRepositoryProvider);

    final allRooms = await chatRepository.getAllRooms(currentUserId);

    chatRepository.watchNewRoomForUser(currentUserId, _addNewRoom);

    return allRooms;
  }

  void _addNewRoom(Room newRoom) async {
    final oldState = await future;
    state = AsyncData([...oldState, newRoom]);
  }
}
