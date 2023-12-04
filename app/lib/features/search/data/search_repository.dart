import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'search_repository.g.dart';

class SearchRepository {
  SearchRepository({required this.supabase});

  final SupabaseClient supabase;

  Future<List<Profile>> searchProfiles(String searchString) async {
    final currentUserId = supabase.auth.currentUser!.id;
    // Search by username for now
    final profiles = await supabase
        .from('profiles')
        .select<List<Map<String, dynamic>>>('id, username')
        .ilike('username', '%$searchString%')
        .neq('id', currentUserId)
        .limit(200);

    return profiles.map((profile) => Profile.fromMap(profile)).toList();
  }
}

@riverpod
SearchRepository searchRepository(SearchRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  return SearchRepository(supabase: supabase);
}
