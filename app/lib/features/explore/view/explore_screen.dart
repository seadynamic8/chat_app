import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/avatar_online_status.dart';
import 'package:chat_app/common/paginated_list_view.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/explore/view/explore_screen_controller.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_extension.dart';

@RoutePage()
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scrollController = ScrollController();
    final stateValue = ref.watch(exploreScreenControllerProvider);

    final getNextPage = ref
        .read(exploreScreenControllerProvider.notifier)
        .getNextPageOfProfiles;

    return I18n(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Home'.i18n),
            actions: [
              IconButton(
                key: K.exploreScreenSearchButton,
                onPressed: () => context.router.push(const SearchRoute()),
                icon: const Icon(Icons.search),
              )
            ],
          ),
          body: PaginatedListView<Profile>(
            scrollController: scrollController,
            getNextPage: getNextPage,
            emptyItemsMessage: 'No online users'.i18n,
            itemsLabel: 'profiles'.i18n,
            value: stateValue,
            beforeSlivers: SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text('Online Now'.i18n),
              ),
            ),
            data: (state) {
              final onlineProfiles = state.items;

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: onlineProfiles.length,
                  (context, index) {
                    final profile = onlineProfiles[index];

                    return ListTile(
                      leading: AvatarOnlineStatus(
                        profileId: profile.id!,
                        radiusSize: 15,
                      ),
                      title: Text(profile.username!),
                      subtitle: profile.gender == null
                          ? const SizedBox.shrink()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  profile.gender?.icon,
                                  size: 15,
                                  color: theme.primaryColorLight,
                                ),
                              ],
                            ),
                      trailing: CountryFlag.fromCountryCode(
                        profile.country!,
                        height: 15,
                        width: 25,
                      ),
                      onTap: () => context.router
                          .push(PublicProfileRoute(profileId: profile.id!)),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
