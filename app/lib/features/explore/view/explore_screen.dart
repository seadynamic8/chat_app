import 'package:auto_route/auto_route.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          body: Container(),
        ),
      ),
    );
  }
}
