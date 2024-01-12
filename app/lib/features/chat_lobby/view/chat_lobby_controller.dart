import 'package:chat_app/common/pagination_state.dart';
import 'package:chat_app/features/chat_lobby/application/chat_lobby_service.dart';
import 'package:chat_app/features/chat_lobby/domain/room.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_lobby_controller.g.dart';

@riverpod
class ChatLobbyController extends _$ChatLobbyController {
  // Make sure this fills the screen or it won't even scroll.
  // Also don't make too small since you don't want to query the API too much.
  static const initialExtraRooms = 0;
  static const numberOfRoomsPerRequest = 15;
  static const initialPage = 0;

  @override
  FutureOr<PaginationState<Room>> build(RoomType roomType) async {
    final chatLobbyService = ref.read(chatLobbyServiceProvider);

    final allRooms = await chatLobbyService.getRooms(
        page: initialPage,
        range: numberOfRoomsPerRequest + initialExtraRooms,
        roomType: roomType);

    await chatLobbyService.roomUpdateHandler(
      roomType: roomType,
      addNewRoomCallback: _addNewRoom,
      removeRoomCallback: _removeRoom,
    );

    return PaginationState<Room>(
      nextPage: initialPage + 1,
      items: allRooms,
    );
  }

  void getNextPageOfRooms() async {
    final oldState = await future;

    final newRooms = await ref.read(chatLobbyServiceProvider).getRooms(
        page: oldState.nextPage!,
        range: numberOfRoomsPerRequest,
        roomType: roomType);

    final isLastPage = newRooms.length < numberOfRoomsPerRequest;
    state = AsyncData(oldState.copyWith(
      isLastPage: isLastPage,
      nextPage: oldState.nextPage! + 1,
      items: [...oldState.items, ...newRooms],
    ));
  }

  void _addNewRoom(Room newRoom) async {
    final oldState = await future;

    if (roomType == RoomType.unRead && _roomExists(oldState.items, newRoom)) {
      return;
    }
    state = AsyncData(oldState.copyWith(
      items: [newRoom, ...oldState.items],
    ));
  }

  void _removeRoom(Room oldRoom) async {
    final oldState = await future;

    final roomIndex = _roomIndexOrNull(oldState.items, oldRoom);
    if (roomIndex == null) return;

    oldState.items.removeAt(roomIndex);
    state = AsyncData(oldState.copyWith(items: [...oldState.items]));
  }

  bool _roomExists(List<Room> roomsList, Room newRoom) {
    final existingRoom =
        roomsList.firstWhereOrNull((room) => room.id == newRoom.id);
    return existingRoom != null;
  }

  int? _roomIndexOrNull(List<Room> roomsList, Room oldRoom) {
    final roomIndex = roomsList.indexWhere((room) => room.id == oldRoom.id);
    return _roomFound(roomIndex) ? roomIndex : null;
  }

  bool _roomFound(int existingRoomIndex) {
    return existingRoomIndex > -1;
  }
}
