import 'package:auto_route/auto_route.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return I18n(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Explore'.i18n),
            actions: [
              IconButton(
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
