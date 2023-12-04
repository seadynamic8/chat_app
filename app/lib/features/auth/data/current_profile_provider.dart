import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_profile_provider.g.dart';

@riverpod
class CurrentProfile extends _$CurrentProfile {
  @override
  Profile build() {
    return const Profile();
  }

  void updateProfile(Profile profile) {
    state = profile;
  }

  void load() async {
    final authRepository = ref.read(authRepositoryProvider);
    final currentUserId = authRepository.currentUserId;

    if (state.username == null && currentUserId != null) {
      ref.listen<AsyncValue<Profile?>>(currentProfileStreamProvider,
          (_, state) {
        if (state.hasValue && state.value != null) {
          updateProfile(state.value!);
        }
      });
    }
  }
}
