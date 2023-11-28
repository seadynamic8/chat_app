import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/alert_dialogs.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

@RoutePage()
class MainNavigation extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;

        final shouldPop = await _showExitConfirmDialog(context);
        if (shouldPop) _exitApp();
      },
      child: const AutoRouter(),
    );
  }
}
