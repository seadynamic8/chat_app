import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat_lobby/data/chat_lobby_repository.dart';
import 'package:chat_app/features/chat_lobby/domain/room.dart';
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
}

@riverpod
ChatLobbyService chatLobbyService(ChatLobbyServiceRef ref) {
  return ChatLobbyService(ref: ref);
}
