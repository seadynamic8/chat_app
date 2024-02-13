import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:chat_app/utils/pagination.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'search_repository.g.dart';

class SearchRepository {
  SearchRepository({required this.supabase});

  final SupabaseClient supabase;

  Future<List<Profile>> searchProfiles({
    required String searchText,
    required String currentUserId,
    required int page,
    required int range,
  }) async {
    final (from: from, to: to) = getPagination(page: page, defaultRange: range);

    try {
      // Search by username for now
      final profiles = await supabase
          .from('profiles')
          .select('id, username')
          .ilike('username', '%$searchText%')
          .neq('id', currentUserId)
          .order('username', ascending: true)
          .range(from, to);

      return profiles.map((profile) => Profile.fromMap(profile)).toList();
    } catch (error, st) {
      logger.error('searchProfiles()', error, st);
      rethrow;
    }
  }
}

@riverpod
SearchRepository searchRepository(SearchRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  return SearchRepository(supabase: supabase);
}
