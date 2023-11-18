import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/home/domain/call_request_state.dart';
import 'package:chat_app/features/home/view/call_request_banner.dart';
import 'package:chat_app/features/home/view/call_request_controller.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
