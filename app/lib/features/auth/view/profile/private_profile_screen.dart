import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:locale_names/locale_names.dart';

@RoutePage()
class PrivateProfileScreen extends ConsumerWidget {
  const PrivateProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileValue = ref.watch(currentProfileStreamProvider);

    return I18n(
      child: SafeArea(
        child: AsyncValueWidget(
          value: profileValue,
          data: (profile) => Scaffold(
            appBar: AppBar(
              title: Text('Profile'.i18n),
              actions: [
                IconButton(
                  key: K.privateProfileEditBtn,
                  onPressed: () =>
                      context.router.push(ProfileEditRoute(profile: profile)),
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                    key: K.privateProfileSettingsBtn,
                    onPressed: () => context.router.push(const SettingsRoute()),
                    icon: const Icon(Icons.settings))
              ],
            ),
            body: ListView(
              children: [
                const SizedBox(height: 30),
                InkWell(
                  key: K.privateProfileInkWellToPublicProfile,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: CircleAvatar(
                          radius: 70,
                          child: CircleAvatar(
                            backgroundImage:
                                const AssetImage(defaultAvatarImage),
                            foregroundImage: profile.avatarUrl == null
                                ? null
                                : NetworkImage(profile.avatarUrl!),
                            radius: 70,
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 0,
                        bottom: 0,
                        right: 40,
                        child: Icon(Icons.keyboard_arrow_right),
                      ),
                    ],
                  ),
                  onTap: () => context.router
                      .push(PublicProfileRoute(profileId: profile.id!)),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        profile.username!,
                        textAlign: TextAlign.center,
                      ),
                      Chip(
                        avatar: Icon(profile.gender == Gender.male
                            ? Icons.male
                            : Icons.female),
                        label: Text(profile.age ?? ''),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CountryFlag.fromCountryCode(
                      profile.country!,
                      height: 15, // Official aspect ratio is 3:5
                      width: 25,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      Locale.fromSubtags(countryCode: profile.country)
                          .nativeDisplayCountry,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      Locale.fromSubtags(
                              languageCode: profile.language!.languageCode,
                              countryCode: profile.language!.countryCode)
                          .nativeDisplayLanguage,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    profile.bio ?? 'Add something interesting here 😀'.i18n,
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
