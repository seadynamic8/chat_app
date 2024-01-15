import 'package:chat_app/env/environment.dart';
import 'package:chat_app/features/chat_lobby/data/chat_lobby_repository.dart';
import 'package:chat_app/features/home/application/notification_service.dart';
import 'package:chat_app/features/home/data/notification_repository.dart';
import 'package:chat_app/features/home/view/notification_snackbar_extension.dart';
import 'package:chat_app/utils/logger.dart';
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
              logError('notificationProfvider build()', error, st),
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
                PaywallRoute(),
                ProfileNavigation(),
              ],
              bottomNavigationBuilder: (_, tabsRouter) {
                final unReadMessageCountStream =
                    ref.watch(unReadMessageCountStreamProvider());

                const regularChatTab = Icon(
                  Icons.message,
                  key: K.chatsTab,
                );

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
                      icon: unReadMessageCountStream.maybeWhen(
                        data: (unReadMessageCount) => unReadMessageCount > 0
                            ? Badge(
                                key: K.chatsBadgeTab,
                                label: Text(unReadMessagesCountString(
                                    unReadMessageCount)),
                                child: const Icon(Icons.message),
                              )
                            : regularChatTab,
                        orElse: () => regularChatTab,
                      ),
                      label: 'Chats'.i18n,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.stars),
                      label: 'Coins'.i18n,
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
