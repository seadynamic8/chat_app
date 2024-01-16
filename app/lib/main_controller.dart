import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'main_controller.g.dart';

@riverpod
class MainController extends _$MainController {
  @override
  FutureOr<void> build() {
    _listenToAuthStateChanges();
  }

  void _listenToAuthStateChanges() {
    ref.listen(authStateChangesProvider, (_, state) {
      state.whenData((authState) {
        switch (authState.event) {
          case AuthChangeEvent.signedIn:
            logger.t('Signed In Event');
          case AuthChangeEvent.signedOut:
            logger.t('Signed Out Event');
          case AuthChangeEvent.userUpdated:
            logger.t('User Updated Event');
          case AuthChangeEvent.tokenRefreshed:
            logger.t('Token Refreshed Event');
          case AuthChangeEvent.userDeleted:
            logger.t('User Deleted Event');
          case AuthChangeEvent.passwordRecovery:
            logger.t('Password Recovery Event');
          case AuthChangeEvent.mfaChallengeVerified:
            logger.t('MFA Challenge Verified Event');
          default:
        }
      });
    });
  }
}
