import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/home/domain/incoming_call_state.dart';
import 'package:chat_app/features/home/view/incoming_call_banner.dart';
import 'package:chat_app/features/home/view/call_request_controller.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class TabsNavigation extends ConsumerWidget {
  const TabsNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This incoming call code was put in the tabs navigation, since it is the
    // first place a user visits after login and is a view with a scaffold.
    // A scaffold is necessary for material banner, which shows on all scaffolds.
    final icbanner = IncomingCallBanner(
      ref: ref,
      router: context.router,
      sMessenger: ScaffoldMessenger.of(context),
    );
    ref.listen<IncomingCallState>(callRequestControllerProvider, (prev, state) {
      switch (state.callType) {
        case IncomingCallType.newCall:
          icbanner.showIncomingCallBanner(
              state.otherUsername!, state.videoRoomId!);
          break;
        case IncomingCallType.cancelCall:
          icbanner.closeIncomingCallBanner();
          ref.read(callRequestControllerProvider.notifier).resetToWaiting();
          break;
        default:
      }
    });

    return I18n(
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
