import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_room_screen_controller.g.dart';

@riverpod
class ChatRoomScreenController extends _$ChatRoomScreenController {
  @override
  FutureOr<Map<String, Profile>> build(String otherProfileId) async {
    final currentProfile = await ref.watch(currentProfileStreamProvider.future);
    final otherProfile =
        await ref.watch(authRepositoryProvider).getProfile(otherProfileId);
    final profiles = {
      currentProfile.id!: currentProfile,
      otherProfile.id!: otherProfile,
    };

    ref.listen<AsyncValue<Profile>>(profileChangesProvider(otherProfileId),
        (_, state) {
      if (state.hasValue) _updateOtherProfile(state.value!);
    });

    return profiles;
  }

  void _updateOtherProfile(Profile updatedOtherProfile) async {
    final oldState = await future;
    oldState[updatedOtherProfile.id!] = updatedOtherProfile;
    state = AsyncData({...oldState});
  }
}
