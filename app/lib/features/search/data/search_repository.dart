import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'search_repository.g.dart';

class SearchRepository {
  SearchRepository({required this.supabase});

  final SupabaseClient supabase;

  Future<List<Profile>> searchProfiles(String searchString) async {
    // Search by username for now
    final profiles = await supabase
        .from('profiles')
        .select<List<Map<String, dynamic>>>('id, username')
        .ilike('username', '%$searchString%')
        .limit(200);

    return profiles.map((profile) => Profile.fromMap(profile)).toList();
  }

  Future<Profile> getProfile(String profileId) async {
    final profileUser = await supabase
        .from('profiles')
        .select<Map<String, dynamic>>()
        .eq('id', profileId)
        .single();

    return Profile.fromMap(profileUser);
  }
}

@riverpod
SearchRepository searchRepository(SearchRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  return SearchRepository(supabase: supabase);
}

@riverpod
FutureOr<Profile> getProfile(GetProfileRef ref, String profileId) {
  final searchRepository = ref.watch(searchRepositoryProvider);
  return searchRepository.getProfile(profileId);
}
