import 'package:chat_app/common/pagination_state.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/search/data/search_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_controller.g.dart';

@riverpod
class SearchController extends _$SearchController {
  // Make sure this fills the screen or it won't even scroll.
  // Also don't make too small since you don't want to query the API too much.
  static const initialExtraProfiles = 0;
  static const numberOfProfilesPerRequest = 15;
  static const initialPage = 0;

  @override
  PaginationState<Profile> build() {
    return PaginationState(items: []);
  }

  Future<void> searchInitialProfiles(String searchText) async {
    final currentUserId = ref.read(currentUserIdProvider)!;
    final profiles = await ref.read(searchRepositoryProvider).searchProfiles(
          searchText: searchText,
          currentUserId: currentUserId,
          page: initialPage,
          range: numberOfProfilesPerRequest + initialExtraProfiles,
        );

    state = PaginationState(nextPage: initialPage + 1, items: profiles);
  }

  Future<void> searchNextProfiles(String searchText) async {
    final currentUserId = ref.read(currentUserIdProvider)!;
    final profiles = await ref.read(searchRepositoryProvider).searchProfiles(
          searchText: searchText,
          currentUserId: currentUserId,
          page: state.nextPage!,
          range: numberOfProfilesPerRequest,
        );

    final isLastPage = profiles.length < numberOfProfilesPerRequest;
    state = state.copyWith(
        isLastPage: isLastPage,
        nextPage: state.nextPage! + 1,
        items: [...state.items, ...profiles]);
  }

  void clearProfiles() {
    state = state.copyWith(items: []);
  }
}
