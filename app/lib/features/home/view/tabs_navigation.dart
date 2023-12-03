import 'package:chat_app/features/chat_lobby/data/chat_lobby_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class TabsNavigation extends ConsumerWidget {
  const TabsNavigation({super.key});

  String unReadMessagesCountString(int unReadCount) {
    if (unReadCount > 999) {
      return '999+';
    }
    return unReadCount.toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return I18n(
      child: AutoTabsScaffold(
        routes: const [
          ExploreNavigation(),
          ChatNavigation(),
          ProfileNavigation(),
        ],
        bottomNavigationBuilder: (_, tabsRouter) {
          final unReadMessageCountStream =
              ref.watch(unReadMessagesStreamProvider());

          const regularChatTab = Icon(
            Icons.message,
            key: K.chatsTab,
          );

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
                  key: K.exploreTab,
                ),
                label: 'Explore'.i18n,
              ),
              BottomNavigationBarItem(
                icon: unReadMessageCountStream.maybeWhen(
                  data: (unReadMessageCount) => unReadMessageCount > 0
                      ? Badge(
                          key: K.chatsBadgeTab,
                          label: Text(
                              unReadMessagesCountString(unReadMessageCount)),
                          child: const Icon(Icons.message),
                        )
                      : regularChatTab,
                  orElse: () => regularChatTab,
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
