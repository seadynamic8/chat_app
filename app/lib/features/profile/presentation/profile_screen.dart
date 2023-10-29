import 'package:auto_route/auto_route.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return I18n(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Profile'.i18n),
            actions: [
              IconButton(
                  onPressed: () =>
                      context.router.push(const ProfileSettingsRoute()),
                  icon: const Icon(Icons.settings))
            ],
          ),
          body: Container(),
        ),
      ),
    );
  }
}
