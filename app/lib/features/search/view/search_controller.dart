import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/search/data/search_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_controller.g.dart';

@riverpod
class SearchController extends _$SearchController {
  @override
  AsyncValue<List<Profile>> build() {
    return const AsyncData([]);
  }

  Future<void> searchProfiles(String searchString) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(searchRepositoryProvider).searchProfiles(searchString));
  }

  void clearProfiles() {
    state = const AsyncData([]);
  }
}
