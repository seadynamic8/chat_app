import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/error_message_widget.dart';
import 'package:chat_app/features/explore/view/explore_screen_controller.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateValue = ref.watch(exploreScreenControllerProvider);

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
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text('Online Now'.i18n),
                ),
              ),
              stateValue.when(
                data: (onlineProfiles) => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: onlineProfiles.length,
                    (context, index) {
                      final profile = onlineProfiles[index];

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: const AssetImage(defaultAvatarImage),
                          foregroundImage: profile.avatarUrl == null
                              ? null
                              : NetworkImage(profile.avatarUrl!),
                        ),
                        title: Text(profile.username!),
                        subtitle: Text('${profile.age!} yrs old.'.i18n),
                        trailing: CountryFlag.fromCountryCode(
                          profile.country!,
                          height: 15,
                          width: 25,
                        ),
                      );
                    },
                  ),
                ),
                loading: () => const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, st) {
                  logError('build() stateValue', e, st);
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: ErrorMessageWidget('Error: Something went wrong'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
