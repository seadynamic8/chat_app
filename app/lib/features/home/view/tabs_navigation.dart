import 'package:chat_app/env/environment.dart';
import 'package:chat_app/features/chat_lobby/data/chat_lobby_repository.dart';
import 'package:chat_app/features/home/application/notification_service.dart';
import 'package:chat_app/features/home/data/notification_repository.dart';
import 'package:chat_app/features/home/view/chat_tab_icon.dart';
import 'package:chat_app/features/home/view/notification_snackbar_extension.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';

@RoutePage()
class TabsNavigation extends ConsumerWidget {
  const TabsNavigation({super.key});

  void _listenToInitialMessage(BuildContext context, WidgetRef ref) {
    ref.listen(initialMessageProvider, (_, state) {
      state.whenData(
        (message) => context.onBackgroundNotificationClicked(
            NotificationType.terminated, message),
      );
    });
  }

  void _listenToClickedBackgroundMessages(BuildContext context, WidgetRef ref) {
    ref.listen(clickedBackgroundMessagesProvider, (_, state) {
      state.whenData(
        (message) => context.onBackgroundNotificationClicked(
            NotificationType.background, message),
      );
    });
  }

  void _listenToForegroundMessages(BuildContext context, WidgetRef ref) {
    ref.listen(foregroundMessagesProvider, (_, state) {
      state.whenData((message) => context.showAppNotification(message));
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isProd = ref.watch(environmentProvider).envType == EnvType.production;

    ref.watch(initializedNotificationsProvider).when(
          data: (notificationRepository) {
            _listenToInitialMessage(context, ref);
            _listenToClickedBackgroundMessages(context, ref);
            _listenToForegroundMessages(context, ref);
          },
          error: (error, st) =>
              logger.error('notificationProfvider build()', error, st),
          loading: () => null,
        );

    return I18n(
      child: Column(
        children: [
          Expanded(
            child: AutoTabsScaffold(
              routes: const [
                ExploreNavigation(),
                ChatNavigation(),
                ProfileNavigation(),
              ],
              bottomNavigationBuilder: (_, tabsRouter) {
                return BottomNavigationBar(
                  currentIndex: tabsRouter.activeIndex,
                  onTap: tabsRouter.setActiveIndex,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  selectedItemColor:
                      theme.textTheme.labelMedium!.decorationColor,
                  unselectedItemColor: theme.colorScheme.primary,
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(
                        // Icons.people_alt_outlined,
                        Icons.home_rounded,
                        key: K.exploreTab,
                      ),
                      label: 'Home'.i18n,
                    ),
                    BottomNavigationBarItem(
                      icon: const ChatTabIcon(),
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
          ),
          if (!isProd)
            TextButton(
              onPressed: () {
                context.router.push(const ErrorTalkerRoute());
              },
              child: const Text('Diagnostics'),
            ),
        ],
      ),
    );
  }
}
