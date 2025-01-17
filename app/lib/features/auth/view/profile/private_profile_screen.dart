import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/common/avatar_image.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/user_access.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:locale_names/locale_names.dart';

@RoutePage()
class PrivateProfileScreen extends ConsumerWidget {
  const PrivateProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileValue = ref.watch(currentProfileStreamProvider);
    final userAccessValue = ref.watch(userAccessStreamProvider);

    return I18n(
      child: SafeArea(
        child: AsyncValueWidget(
          value: profileValue,
          data: (profile) => profile == null
              ? Center(
                  child: Text('No profile'.i18n),
                )
              : Scaffold(
                  appBar: AppBar(
                    title: Text('Profile'.i18n),
                    actions: [
                      IconButton(
                        key: K.privateProfileEditBtn,
                        onPressed: () => context.router
                            .push(ProfileEditRoute(profile: profile)),
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                          key: K.privateProfileSettingsBtn,
                          onPressed: () =>
                              context.router.push(const SettingsRoute()),
                          icon: const Icon(Icons.settings))
                    ],
                  ),
                  body: ListView(
                    children: [
                      const SizedBox(height: 30),
                      InkWell(
                        key: K.privateProfileInkWellToPublicProfile,
                        child: SizedBox(
                          width: double.infinity,
                          child: CircleAvatar(
                            radius: 70,
                            child: AvatarImage(
                              profileId: profile.id!,
                              radiusSize: 70,
                            ),
                          ),
                        ),
                        onTap: () => context.router
                            .push(PublicProfileRoute(profileId: profile.id!)),
                      ),
                      const SizedBox(height: 25),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // USERNAME
                            Text(
                              profile.username!,
                              textAlign: TextAlign.center,
                            ),

                            // GENDER AND AGE
                            Chip(
                              avatar: Icon(profile.gender?.icon),
                              label: Text(profile.age ?? ''),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // COUNTRY FLAG
                          CountryFlag.fromCountryCode(
                            profile.country!,
                            height: 15, // Official aspect ratio is 3:5
                            width: 25,
                          ),
                          const SizedBox(width: 15),

                          // COUNTRY
                          Text(
                            Locale.fromSubtags(countryCode: profile.country)
                                .nativeDisplayCountry,
                          ),
                          const SizedBox(width: 15),

                          // LANGUAGE
                          Text(
                            Locale.fromSubtags(
                                    languageCode:
                                        profile.language!.languageCode,
                                    countryCode: profile.language!.countryCode)
                                .nativeDisplayLanguage,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // SHOW PROFILE BUTTON
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                          onPressed: () => context.router
                              .push(PublicProfileRoute(profileId: profile.id!)),
                          child: const Text('Show Profile'),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // SUBSCRIPTION
                      AsyncValueWidget(
                        value: userAccessValue,
                        data: (userAccess) => userAccess == null
                            ? Center(
                                child: Text('No user subscription'.i18n),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: switch (userAccess.level) {
                                  AccessLevel.trial => Chip(
                                      label:
                                          Text('Free Trial (60 minutes)'.i18n)),
                                  AccessLevel.standard => OutlinedButton(
                                      onPressed: () => context.router.push(
                                        const PaywallRoute(),
                                      ),
                                      child: const Text('Subscribe to Premium'),
                                    ),
                                  AccessLevel.premium => Chip(
                                      label: Text('Premium Subscription'.i18n),
                                    ),
                                  AccessLevel.free => Chip(
                                      label: Text('Free Subscription'.i18n),
                                    ),
                                },
                              ),
                      ),
                      const SizedBox(height: 20),

                      // BIO
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          profile.bio ??
                              'Add something interesting here 😀'.i18n,
                          textAlign: TextAlign.center,
                        ),
                      )
                      // TODO: Insert # of Follow, Followers, and Views
                      // TODO: Insert # Coins and Buy Coins
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
