import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat_lobby/data/chat_lobby_repository.dart';
import 'package:chat_app/features/chat_lobby/domain/room.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'public_profile_controller.g.dart';

@riverpod
class PublicProfileController extends _$PublicProfileController {
  @override
  void build() {}

  Future<Room> findOrCreateRoom(String viewingProfileId) async {
    final currentProfileId = ref.read(authRepositoryProvider).currentUserId!;

    // Find room with other user
    var room = await ref.read(chatLobbyRepositoryProvider).findRoomByProfiles(
        currentProfileId: currentProfileId, otherProfileId: viewingProfileId);

    if (room != null) return room;

    // If no current room exists, create new and join both users and return room
    return await _createRoomAndJoin(viewingProfileId);
  }

  Future<Room> _createRoomAndJoin(String viewingProfileId) async {
    final room = await ref.read(chatLobbyRepositoryProvider).createRoom();

    await _addBothUsersToRoom(
        viewingProfileId: viewingProfileId, roomId: room.id);

    return room;
  }

  Future<void> _addBothUsersToRoom({
    required String viewingProfileId,
    required String roomId,
  }) async {
    final currentUserId = ref.read(authRepositoryProvider).currentUserId!;

    await ref
        .read(chatLobbyRepositoryProvider)
        .addUserToRoom(currentUserId, roomId);
    await ref
        .read(chatLobbyRepositoryProvider)
        .addUserToRoom(viewingProfileId, roomId);
  }
}
