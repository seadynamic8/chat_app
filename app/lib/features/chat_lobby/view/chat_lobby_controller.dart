import 'package:chat_app/common/pagination_state.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat_lobby/application/chat_lobby_service.dart';
import 'package:chat_app/features/chat_lobby/data/chat_lobby_repository.dart';
import 'package:chat_app/features/chat_lobby/domain/room.dart';
import 'package:chat_app/utils/list_extension.dart';
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

    _roomUpdateHandler();

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

  void _roomUpdateHandler() {
    switch (roomType) {
      case RoomType.all:
        _allRoomsHandler();
      case RoomType.unRead:
        _unReadRoomsHandler();
      case RoomType.requests:
        _requestedRoomsHandler();
    }
  }

  void _allRoomsHandler() {
    ref.listen<AsyncValue<Room>>(joinedRoomProvider, (_, state) {
      state.whenData(_addNewRoom);
    });
  }

  void _unReadRoomsHandler() {
    ref.listen<AsyncValue<Room>>(newUnReadJoinedRoomProvider, (_, state) {
      state.whenData(_addNewRoom);
    });
    ref.listen<AsyncValue<Room>>(newReadRoomProvider, (_, state) {
      state.whenData(_removeRoom);
    });
  }

  void _requestedRoomsHandler() {
    ref.listen<AsyncValue<Room>>(newRequestedRoomProvider, (_, state) {
      state.whenData(_addNewRoom);
    });
    ref.listen<AsyncValue<Room>>(joinedRoomProvider, (_, state) {
      state.whenData(_removeRoom);
    });
  }

  void _addNewRoom(Room newRoom) async {
    final oldState = await future;

    if (roomType == RoomType.unRead && Room.exists(oldState.items, newRoom)) {
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

  int? _roomIndexOrNull(List<Room> roomsList, Room room) {
    return roomsList.indexWhereOrNull((r) => r.id == room.id);
  }
}
