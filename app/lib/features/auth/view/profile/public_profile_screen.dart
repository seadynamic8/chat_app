import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/view/profile/public_profile_buttons.dart';
import 'package:chat_app/features/home/application/current_user_id_provider.dart';
import 'package:chat_app/features/home/application/online_presence_provider.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:locale_names/locale_names.dart';

@RoutePage()
class PublicProfileScreen extends ConsumerWidget {
  const PublicProfileScreen(
      {super.key, @PathParam('id') required this.profileId});

  final String profileId;

  bool isCurrentUser(WidgetRef ref) {
    return profileId == ref.watch(currentUserIdProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileValue = ref.watch(profileStreamProvider(profileId));

    return I18n(
      child: AsyncValueWidget(
        value: profileValue,
        data: (profile) {
          final onlinePresencesValue =
              ref.watch(onlinePresenceProvider(profileId));

          return profile == null
              ? Center(
                  child: Text('Profile not found'.i18n),
                )
              : Scaffold(
                  key: K.publicProfile,
                  body: ListView(
                    children: [
                      Stack(
                        children: [
                          // Main User Image
                          Container(
                            key: K.publicProfileAvatarCoverImg,
                            decoration: const BoxDecoration(
                              color: Colors.black26,
                            ),
                            width: double.infinity,
                            height: 400,
                            child: profile.avatarUrl != null
                                ? Image.network(profile.avatarUrl!,
                                    fit: BoxFit.cover)
                                : Padding(
                                    padding: const EdgeInsets.all(70.0),
                                    child: Image.asset(
                                      defaultAvatarImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          // Back Button
                          Positioned(
                            left: 5,
                            top: 10,
                            child: IconButton(
                              key: K.publicProfileBackButton,
                              icon: const Icon(
                                Icons.arrow_back,
                                shadows: [
                                  Shadow(color: Colors.black, blurRadius: 10),
                                ],
                              ),
                              onPressed: () {
                                context.router.maybePop();
                              },
                            ),
                          ),
                          // Username (and online status)
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // USERNAME
                            Text(
                              profile.username ?? '',
                              style: theme.textTheme.bodyLarge!.copyWith(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 15),

                            // ONLINE STATUS
                            onlinePresencesValue.maybeWhen(
                              data: (userStatus) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: userStatus.color,
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: Text(userStatus.name,
                                      style: theme.textTheme.labelMedium),
                                );
                              },
                              orElse: SizedBox.shrink,
                            ),
                            // TODO: Follow button
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            // GENDER AND AGE
                            Chip(
                              avatar: Icon(profile.gender?.icon),
                              label: Text(profile.age ?? ''),
                            ),
                            const SizedBox(width: 12),

                            // COUNTRY
                            CountryFlag.fromCountryCode(
                              profile.country!,
                              height: 15,
                              width: 25,
                            ),
                            const SizedBox(width: 5),
                            Text(Locale.fromSubtags(
                                    countryCode: profile.country!)
                                .nativeDisplayCountry),
                          ],
                        ),
                      ),

                      // BIO
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        child: Text(profile.bio ?? 'Nothing here yet 😀'),
                      ),

                      // TODO: How many follows
                      // TODO: Posts (or Moments)
                    ],
                  ),
                  floatingActionButton: isCurrentUser(ref)
                      ? null
                      : PublicProfileButtons(otherProfileId: profileId),
                  floatingActionButtonLocation: isCurrentUser(ref)
                      ? null
                      : FloatingActionButtonLocation.centerFloat,
                );
        },
      ),
    );
  }
}
