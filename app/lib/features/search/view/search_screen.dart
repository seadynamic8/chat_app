import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/avatar_online_status.dart';
import 'package:chat_app/common/paginated_list_view.dart';
import 'package:chat_app/common/pagination_state.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/search/view/search_screen_controller.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/debouncer.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_extension.dart';

@RoutePage()
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final debounceTime = const Duration(milliseconds: 500);

  String get searchText => _searchController.text.trim();

  void _search() {
    if (searchText.isEmpty) {
      ref.read(searchScreenControllerProvider.notifier).reset();
      return;
    }

    final debouncer = Debouncer(delay: debounceTime);
    debouncer.run(() async {
      await ref
          .read(searchScreenControllerProvider.notifier)
          .searchInitialProfiles(searchText);
    });
  }

  void getNextPage(searchText) => ref
      .read(searchScreenControllerProvider.notifier)
      .searchNextProfiles(searchText);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    final state = ref.watch(searchScreenControllerProvider);

    return I18n(
      child: SafeArea(
        child: Scaffold(
          key: K.searchScreen,
          appBar: AppBar(
            title: TextField(
              key: K.searchScreenSearchField,
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by Username....',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => _search(),
            ),
          ),
          body: PaginatedListView<Profile>(
            scrollController: scrollController,
            getNextPage: getNextPage,
            itemsLabel: 'profiles'.i18n,
            state: state,
            data: (state) {
              final profiles = state.items;

              return switch (state.resultsState) {
                PaginationResultsState.before =>
                  emptyResults('Search above for users'),
                PaginationResultsState.none => emptyResults('No users found'),
                PaginationResultsState.results || null => SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: profiles.length,
                      (context, index) {
                        final profile = profiles[index];

                        return ListTile(
                          key: K.searchScreenResultTile,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          leading: AvatarOnlineStatus(
                            key: K.chatLobbyItemAvatar,
                            profileId: profile.id!,
                            radiusSize: 20,
                          ),
                          title: Text(
                            profile.username ?? '',
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            maxLines: 1,
                          ),
                          onTap: () => context.router.push(
                            PublicProfileRoute(profileId: profile.id!),
                          ),
                        );
                      },
                    ),
                  ),
              };
            },
          ),
        ),
      ),
    );
  }

  Widget emptyResults(String message) {
    return SliverFillRemaining(
      child: Center(
        child: Text(message.i18n),
      ),
    );
  }
}
