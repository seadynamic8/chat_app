import 'package:chat_app/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthAdminRepository {
  AuthAdminRepository();

  final SupabaseClient supabase = Supabase.instance.client;

  Future<String> createUser({
    required String email,
    String? password,
    bool emailConfirm = true,
    String username = 'fakeUser123456',
  }) async {
    late final FunctionResponse response;
    try {
      response = await supabase.functions.invoke('create_user', body: {
        'email': email,
        'password': password,
        'emailConfirm': emailConfirm,
        'username': username,
      });
    } catch (error) {
      logger.e('AuthAdminRepository createUser error: $error');
    }
    if (response.data.isEmpty) {
      logger.e('AuthAdminRepository createUser error: Empty response');
      throw Exception('Empty response');
    }

    return response.data['user']['id'];
  }

  Future<String?> getUserIdByEmail(String email) async {
    final response = await supabase.functions
        .invoke('get_user_id_by_email', body: {'email': email});

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
    final userId = await getUserIdByEmail(email);
    if (userId != null && userId.isNotEmpty) deleteUser(userId);
  }
}
