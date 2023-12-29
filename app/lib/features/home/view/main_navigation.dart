import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/alert_dialogs.dart';
import 'package:chat_app/features/home/domain/call_request_state.dart';
import 'package:chat_app/features/home/view/call_request_banner.dart';
import 'package:chat_app/features/home/view/call_request_controller.dart';
import 'package:chat_app/features/home/view/main_navigation_controller.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class MainNavigation extends ConsumerWidget {
  const MainNavigation({super.key});

  Future<bool> _showExitConfirmDialog(BuildContext context) async {
    final exitResult = await showAlertDialog(
        context: context,
        title: 'Please confirm'.i18n,
        content: 'Do you want to exit the app?'.i18n,
        cancelActionText: 'No',
        defaultActionText: 'Yes');
    return exitResult ?? false;
  }

  void _exitApp() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This is primarily used to preload app after login
    ref.watch(mainNavigationControllerProvider);

    // This incoming call request banner was put here, since it is the
    // first place a user visits after login and is a screen with a scaffold.
    // A scaffold is necessary for material banner, which shows on all scaffolds.
    // Also, instead of TabsNavigation, when pushed from here, the bottom tabs
    // won't show on the video.
    final cqbanner = CallRequestBanner(
      ref: ref,
      router: context.router,
      sMessenger: ScaffoldMessenger.of(context),
    );
    ref.listen<CallRequestState>(callRequestControllerProvider, (prev, state) {
      switch (state.callType) {
        case CallRequestType.newCall:
          cqbanner.showCallRequestBanner();
        case CallRequestType.cancelCall:
          cqbanner.closeCallRequestBanner();
          ref.read(callRequestControllerProvider.notifier).resetToWaiting();
        default:
      }
    });

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;

        final shouldPop = await _showExitConfirmDialog(context);
        if (shouldPop) _exitApp();
      },
      // Scaffold is just for material banner to show
      child: const Scaffold(
        body: AutoRouter(),
      ),
    );
  }
}
