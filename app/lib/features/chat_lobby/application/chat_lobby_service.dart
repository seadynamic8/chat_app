import 'package:chat_app/features/auth/data/current_profile_provider.dart';
import 'package:chat_app/features/chat_lobby/data/chat_lobby_repository.dart';
import 'package:chat_app/features/chat_lobby/domain/room.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_lobby_service.g.dart';

class ChatLobbyService {
  ChatLobbyService({required this.ref});

  final Ref ref;

  Future<Room> findOrCreateRoom(String otherProfileId) async {
    final existingRoom =
        await ref.read(findRoomWithUserProvider(otherProfileId).future);
    if (existingRoom != null) return existingRoom;

    return await createAndJoinRoom(otherProfileId);
  }

  Future<Room> createAndJoinRoom(String otherProfileId) async {
    final newRoom = await ref.read(chatLobbyRepositoryProvider).createRoom();

    await _addBothUsersToRoom(
        otherProfileId: otherProfileId, roomId: newRoom.id);

    return newRoom;
  }

  Future<void> _addBothUsersToRoom({
    required String otherProfileId,
    required String roomId,
  }) async {
    final currentProfileId = ref.read(currentProfileProvider).id!;
    await ref
        .read(chatLobbyRepositoryProvider)
        .addUserToRoom(currentProfileId, roomId);
    await ref
        .read(chatLobbyRepositoryProvider)
        .addUserToRoom(otherProfileId, roomId);
  }
}

@riverpod
ChatLobbyService chatLobbyService(ChatLobbyServiceRef ref) {
  return ChatLobbyService(ref: ref);
}
