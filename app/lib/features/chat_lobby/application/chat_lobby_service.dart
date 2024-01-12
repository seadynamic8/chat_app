import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat_lobby/data/chat_lobby_repository.dart';
import 'package:chat_app/features/chat_lobby/domain/room.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_lobby_service.g.dart';

class ChatLobbyService {
  ChatLobbyService({required this.ref});

  final Ref ref;

  Future<Room> findOrCreateRoom(String otherProfileId) async {
    final existingRoom = await _getExistingRoomOrNull(otherProfileId);
    if (existingRoom != null) return existingRoom;

    return await createAndJoinRoom(otherProfileId);
  }

  Future<Room> createAndJoinRoom(String otherProfileId) async {
    final newRoom = await ref.read(chatLobbyRepositoryProvider).createRoom();

    await _addBothUsersToRoom(
        otherProfileId: otherProfileId, roomId: newRoom.id);

    return newRoom;
  }

  Future<Room?> _getExistingRoomOrNull(String otherProfileId) async {
    return await ref.read(findRoomWithUserProvider(otherProfileId).future);
  }

  Future<void> _addBothUsersToRoom({
    required String otherProfileId,
    required String roomId,
  }) async {
    final currentUserId = ref.read(currentUserIdProvider)!;
    await ref
        .read(chatLobbyRepositoryProvider)
        .addUserToRoom(currentUserId, roomId);
    await ref
        .read(chatLobbyRepositoryProvider)
        .addUserToRoom(otherProfileId, roomId);
  }

  Future<List<Room>> getRooms({
    required int page,
    required int range,
    required RoomType roomType,
  }) async {
    switch (roomType) {
      case RoomType.all:
        return await ref.read(allRoomsProvider(
          page,
          range,
        ).future);
      case RoomType.unRead:
        return await ref.read(unReadOnlyRoomsProvider(page, range).future);
      default:
        return [];
    }
  }

  Future<void> roomUpdateHandler({
    required RoomType roomType,
    required void Function(Room newRoom) addNewRoomCallback,
    required void Function(Room oldRoom) removeRoomCallback,
  }) async {
    final currentUserId = ref.read(currentUserIdProvider)!;
    final chatLobbyRepository = ref.read(chatLobbyRepositoryProvider);

    switch (roomType) {
      case RoomType.all:
        chatLobbyRepository.watchNewRoomForUser(
            currentUserId, addNewRoomCallback);
      case RoomType.unRead:
        logger.i('adding unRead handlers');
        chatLobbyRepository.watchNewUnReadMessage(
            currentUserId, addNewRoomCallback);

        chatLobbyRepository.watchNewReadMessage(
            currentUserId, removeRoomCallback);
      default:
    }
  }
}

@riverpod
ChatLobbyService chatLobbyService(ChatLobbyServiceRef ref) {
  return ChatLobbyService(ref: ref);
}
