import 'package:chat_app/common/pagination_state.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat_lobby/data/chat_lobby_repository.dart';
import 'package:chat_app/features/chat_lobby/domain/room.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_lobby_controller.g.dart';

@riverpod
class ChatLobbyController extends _$ChatLobbyController {
  // Make sure this fills the screen or it won't even scroll.
  // Also don't make too small since you don't want to query the API too much.
  static const initialExtraRooms = 10;
  static const numberOfRoomsPerRequest = 5;
  static const initialPage = 0;

  @override
  FutureOr<PaginationState<Room>> build() async {
    final currentUserId = ref.watch(authRepositoryProvider).currentUserId!;
    final chatLobbyRepository = ref.watch(chatLobbyRepositoryProvider);

    final allRooms = await chatLobbyRepository.getAllRooms(
      currentUserId,
      initialPage,
      numberOfRoomsPerRequest + initialExtraRooms,
    );

    chatLobbyRepository.watchNewRoomForUser(currentUserId, _addNewRoom);

    return PaginationState<Room>(nextPage: initialPage + 1, items: allRooms);
  }

  void getNextPageOfRooms() async {
    final oldState = await future;

    final currentUserId = ref.watch(authRepositoryProvider).currentUserId!;
    final newRooms = await ref.watch(chatLobbyRepositoryProvider).getAllRooms(
          currentUserId,
          oldState.nextPage,
          numberOfRoomsPerRequest,
        );

    final isLastPage = newRooms.length < numberOfRoomsPerRequest;
    state = AsyncData(oldState.copyWith(
      isLastPage: isLastPage,
      nextPage: oldState.nextPage + 1,
      items: [...oldState.items, ...newRooms],
    ));
  }

  void _addNewRoom(Room newRoom) async {
    final oldState = await future;
    state = AsyncData(oldState.copyWith(
      items: [newRoom, ...oldState.items],
    ));
  }
}
