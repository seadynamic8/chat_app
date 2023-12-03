import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat_lobby/data/chat_lobby_repository.dart';
import 'package:chat_app/features/chat_lobby/domain/room.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_lobby_controller.g.dart';

@riverpod
class ChatLobbyController extends _$ChatLobbyController {
  @override
  FutureOr<List<Room>> build() async {
    final currentUserId = ref.watch(authRepositoryProvider).currentUserId!;
    final chatLobbyRepository = ref.watch(chatLobbyRepositoryProvider);

    final allRooms = await chatLobbyRepository.getAllRooms(currentUserId);

    chatLobbyRepository.watchNewRoomForUser(currentUserId, _addNewRoom);

    return allRooms;
  }

  void _addNewRoom(Room newRoom) async {
    final oldState = await future;
    state = AsyncData([...oldState, newRoom]);
  }
}
