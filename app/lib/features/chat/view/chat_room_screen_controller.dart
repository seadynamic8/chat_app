import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/domain/chat_room.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_room_screen_controller.g.dart';

@riverpod
class ChatRoomScreenController extends _$ChatRoomScreenController {
  @override
  FutureOr<ChatRoom> build(String roomId, String otherProfileId) async {
    final currentProfile = await ref.watch(currentProfileStreamProvider.future);
    final otherProfile =
        await ref.watch(profileStreamProvider(otherProfileId).future);
    await ref.watch(authRepositoryProvider).getProfile(otherProfileId);
    final profiles = {
      currentProfile!.id!: currentProfile,
      otherProfile.id!: otherProfile,
    };

    final joined = await ref
        .read(chatRepositoryProvider)
        .getJoinStatus(roomId, currentProfile.id!);

    if (joined == false) {
      ref.listen<AsyncValue<bool>>(onJoinForRoomProvider(roomId), (_, state) {
        state.whenData((joined) => _updateJoinStatus(joined));
      });
    }

    return ChatRoom(id: roomId, profiles: profiles, joined: joined);
  }

  void _updateJoinStatus(bool joined) async {
    final oldState = await future;
    state = AsyncData(oldState.copyWith(joined: joined));
  }
}
