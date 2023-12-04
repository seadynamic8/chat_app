import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/auth_admin_repository.dart';
import 'common/email_api.dart';

class TestHelper {
  final authAdminRepository = AuthAdminRepository();
  final authRepository = ProviderContainer().read(authRepositoryProvider);

  Future<void> signOut() async {
    if (authRepository.currentUserId != null) {
      await authRepository.signOut();
    }
  }

  // Often used both in setUp and tearDown to ensure fake users are cleared
  // Unfortunately, no easy way to do transactions with Supabase Api.
  // This doesn't always work because the test may fail mid way.
  Future<void> clearUser({required String email}) async {
    await authAdminRepository.deleteUserByEmail(email);
  }

  Future<String> createUser({
    required String email,
    String? password,
    String? username,
    bool? autoConfirmEmail,
  }) async {
    await clearUser(email: email);

    return await authAdminRepository.createUser(
      email: email,
      password: password,
      username: username,
      autoConfirmEmail: autoConfirmEmail,
    );
  }

  Future<String> createAndLoginUser({
    required String email,
    required String password,
    String? username,
  }) async {
    final userId = await createUser(
      email: email,
      password: password,
      username: username,
    );
    await authRepository.signInWithEmailAndPassword(
        email: email, password: password);
    return userId;
  }

  Future<String> getEmailOTP(String email) async {
    final emailApi = EmailApi();
    final mailboxName = email.split('@').first;
    final lastEmailId = await emailApi.getLastEmailId(mailboxName);
    return await emailApi.getCodeFromEmail(mailboxName, lastEmailId);
  }
}
