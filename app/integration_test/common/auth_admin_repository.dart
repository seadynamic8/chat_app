import 'package:supabase_flutter/supabase_flutter.dart';

class AuthAdminRepository {
  AuthAdminRepository();

  final SupabaseClient supabase = Supabase.instance.client;

  Future<String?> createUser({
    required String email,
    String? password,
    bool emailConfirm = true,
    String username = 'fakeUser123456',
  }) async {
    final response = await supabase.functions.invoke('create_user', body: {
      'email': email,
      'password': password,
      'emailConfirm': emailConfirm,
      'username': username,
    });
    if (response.data == null) return null;

    return response.data['id'];
  }

  Future<String?> getUserIdByEmail(String email) async {
    final response = await supabase.functions
        .invoke('get_user_id_by_email', body: {'email': email});

    if (response.data == null) return null;

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
