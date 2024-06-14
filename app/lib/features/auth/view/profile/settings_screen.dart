import 'package:chat_app/common/terms_and_privacy_text.dart';
import 'package:chat_app/features/auth/view/profile/settings_screen_controller.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';

@RoutePage()
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _logOut(BuildContext context, WidgetRef ref) async {
    final router = context.router;

    await ref.read(settingsScreenControllerProvider.notifier).logOut();

    router.replaceAll([const MainNavigation()]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return I18n(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Settings'.i18n),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      key: K.settingsLogoutTile,
                      title: Text('Logout'.i18n),
                      onTap: () => _logOut(context, ref),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    TermsAndPrivacyText(textColor: theme.hintColor),
                    Text(
                      'Copyright © 2023-${DateTime.now().year} Star Cache, LLC'
                          .i18n,
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                    Text(
                      'All rights reserved.'.i18n,
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
