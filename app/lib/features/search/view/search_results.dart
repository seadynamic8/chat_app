import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/avatar_online_status.dart';
import 'package:chat_app/common/paginated_list_view.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/search/view/search_controller.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchResults extends ConsumerStatefulWidget {
  const SearchResults({
    super.key,
    required this.debounceTime,
    required this.getNextPage,
  });

  final Duration debounceTime;
  final void Function() getNextPage;

  @override
  ConsumerState<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends ConsumerState<SearchResults> {
  var _timerFinished = false;

  Widget noResults() {
    const extraLoadProfilesTime = Duration(milliseconds: 100);
    Timer(widget.debounceTime + extraLoadProfilesTime, () {
      setState(() => _timerFinished = true);
    });
    return _timerFinished
        ? SliverFillRemaining(
            child: Center(
              child: Text('No users found'.i18n),
            ),
          )
        : const SliverToBoxAdapter();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final state = ref.watch(searchControllerProvider);

    return PaginatedListView<Profile>(
      scrollController: scrollController,
      getNextPage: widget.getNextPage,
      itemsLabel: 'profiles'.i18n,
      state: state,
      data: (state) {
        final profiles = state.items;

        return profiles.isEmpty
            ? noResults()
            : SliverList(
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
              );
      },
    );
  }
}
