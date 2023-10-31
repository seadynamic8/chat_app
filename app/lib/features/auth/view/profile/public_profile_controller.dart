import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/domain/room.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'public_profile_controller.g.dart';

@riverpod
class PublicProfileController extends _$PublicProfileController {
  @override
  void build() {}

  Future<Room> createRoom() async {
    return await ref.read(chatRepositoryProvider).createRoom();
  }

  Future<void> addUserToRoom(String profileId, String roomId) async {
    await ref.read(chatRepositoryProvider).addUserToRoom(profileId, roomId);
  }

  Future<void> addBothUsersToRoom({
    required String viewingProfileId,
    required String roomId,
  }) async {
    final currentUserId = ref.read(authRepositoryProvider).currentUserId!;

    await ref
        .read(publicProfileControllerProvider.notifier)
        .addUserToRoom(currentUserId, roomId);
    await ref
        .read(publicProfileControllerProvider.notifier)
        .addUserToRoom(viewingProfileId, roomId);
  }
}
