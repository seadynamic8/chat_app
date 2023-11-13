import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_profile_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentProfile extends _$CurrentProfile {
  @override
  Profile build() {
    return const Profile();
  }

  void set(Profile profile) {
    state = profile;
  }

  Future<void> load() async {
    if (state.username == null) {
      final currentUserId = ref.read(authRepositoryProvider).currentUserId!;
      state = await ref.read(authRepositoryProvider).getProfile(currentUserId);
    }
  }
}
