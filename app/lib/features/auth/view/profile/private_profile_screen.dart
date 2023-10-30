import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class PrivateProfileScreen extends ConsumerWidget {
  const PrivateProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileUser = ref.watch(currentProfileProvider).value;

    return I18n(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Profile'.i18n),
            actions: [
              IconButton(
                  onPressed: () => context.router.push(const SettingsRoute()),
                  icon: const Icon(Icons.settings))
            ],
          ),
          body: ListView(
            children: [
              const SizedBox(height: 30),
              CircleAvatar(
                radius: 70,
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: AssetImage(profileUser?.avatarUrl ??
                      'assets/images/user_default_image.png'),
                  radius: 70,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      profileUser?.username ?? 'Default User',
                      textAlign: TextAlign.center,
                    ),
                    const Chip(
                      avatar: Icon(Icons.male),
                      label: Text('37'),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // TODO: Insert Flag and Country
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '*** BIO *** Reprehenderit nostrud nostrud ex dolor irure ullamco anim amet excepteur tempor in aute ad. Qui quis anim do in. Lorem pariatur sint duis tempor magna ea enim id ad quis consectetur. Sunt duis aute est occaecat fugiat eu sunt eu laborum cupidatat est consequat proident veniam. Nostrud et aliqua officia laboris aliqua aute dolor occaecat laborum est dolore. Voluptate commodo ad in ullamco amet excepteur sint laborum id deserunt duis exercitation fugiat.',
                  textAlign: TextAlign.center,
                ),
              )
              // TODO: Insert # of Follow, Followers, and Views
              // TODO: Insert # Coins and Buy Coins
            ],
          ),
        ),
      ),
    );
  }
}
