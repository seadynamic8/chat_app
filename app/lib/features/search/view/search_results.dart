import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/avatar_online_status.dart';
import 'package:chat_app/common/paginated_list_view.dart';
import 'package:chat_app/common/pagination_state.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/search/view/search_controller.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchResults extends ConsumerWidget {
  const SearchResults({super.key, required this.getNextPage});

  final void Function() getNextPage;

  Widget emptyResults(String message) {
    return SliverFillRemaining(
      child: Center(
        child: Text(message.i18n),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ScrollController();
    final state = ref.watch(searchControllerProvider);

    return PaginatedListView<Profile>(
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
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
    );
  }
}
