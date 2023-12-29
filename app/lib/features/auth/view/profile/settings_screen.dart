import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _logOut(BuildContext context, WidgetRef ref) async {
    final router = context.router;

    await ref.read(authRepositoryProvider).signOut();

    router.replaceAll([const MainNavigation()]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return I18n(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Settings'.i18n),
          ),
          body: ListView(
            children: [
              ListTile(
                key: K.settingsLogoutTile,
                title: Text('Logout'.i18n),
                onTap: () => _logOut(context, ref),
              )
            ],
          ),
        ),
      ),
    );
  }
}
