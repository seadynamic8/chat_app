import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'current_user_id_provider.g.dart';

@riverpod
class CurrentUserId extends _$CurrentUserId {
  @override
  String? build() {
    final authRepository = ref.watch(authRepositoryProvider);

    ref.listen(authStateChangesProvider, (_, state) {
      state.whenData((authState) {
        if (authState.event == AuthChangeEvent.signedIn) {
          _updateCurrentUserId();
        }
      });
    });

    return authRepository.currentUserId;
  }

  void _updateCurrentUserId() {
    state = ref.read(authRepositoryProvider).currentUserId;
  }
}
