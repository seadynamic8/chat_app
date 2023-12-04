import 'package:chat_app/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthAdminRepository {
  AuthAdminRepository();

  final SupabaseClient supabase = Supabase.instance.client;

  Future<String> createUser({
    required String email,
    String? password,
    bool? autoConfirmEmail,
    String? username,
  }) async {
    late final FunctionResponse response;
    try {
      response = await supabase.functions.invoke('create_user', body: {
        'email': email.toLowerCase(),
        'password': password,
        'autoConfirmEmail': autoConfirmEmail ?? true,
        'username': username ?? 'fakeUser123456',
      });
    } catch (error) {
      logger.e(
          'AuthAdminRepository createUser error: email[${email.toLowerCase()}] :$error');
    }
    if (response.data.isEmpty) {
      logger.e('AuthAdminRepository createUser error: Empty response');
      throw Exception('Empty response');
    }

    return response.data['user']['id'];
  }

  Future<String?> getUserIdByEmail(String email) async {
    final response = await supabase.functions
        .invoke('get_user_id_by_email', body: {'email': email.toLowerCase()});

    if (response.data == null) {
      logger.w('AuthAdminRespository getUserIdByEmail error: Null response');
      return null;
    }
    if (response.data.isEmpty) {
      logger.w(
          'AuthAdminRespository getUserIdByEmail: Could not find user (empty response)');
      return null;
    }

    return response.data['id'];
  }

  Future<void> deleteUser(String userId) async {
    await supabase.functions.invoke('delete_user', body: {'userId': userId});
  }

  Future<void> deleteUserByEmail(String email) async {
    final userId = await getUserIdByEmail(email.toLowerCase());
    if (userId != null && userId.isNotEmpty) {
      await deleteUser(userId);
    }
  }
}
