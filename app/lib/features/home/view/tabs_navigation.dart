import 'package:auto_route/auto_route.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class TabsNavigation extends StatelessWidget {
  const TabsNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return I18n(
      child: AutoTabsScaffold(
        routes: const [
          ExploreRoute(),
          ChatLobbyRoute(),
          PrivateProfileRoute(),
        ],
        bottomNavigationBuilder: (_, tabsRouter) {
          return BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            // TODO: Update color to something than just some random color
            selectedItemColor:
                Theme.of(context).textTheme.labelMedium!.decorationColor,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.people_alt_outlined,
                  key: K.contactsTab,
                ),
                label: 'Explore'.i18n,
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.message,
                  key: K.chatsTab,
                ),
                label: 'Chats'.i18n,
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.person,
                  key: K.profileTab,
                ),
                label: 'Profile'.i18n,
              ),
            ],
          );
        },
      ),
    );
  }
}
