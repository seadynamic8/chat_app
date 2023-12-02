import 'package:chat_app/main.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'app_initializer.dart';
import 'test_helper.dart';

class Robot {
  Robot({required this.$});

  final PatrolIntegrationTester $;

  Future<void> pumpAndSettleMyApp(
      {bool preSetup = true, List<Override>? overrides}) async {
    // Don't need WidgetsFlutterBinding.ensureInitialized() because Patrol does it

    if (preSetup) {
      await AppInitializer().setup();
    }
    await $.pumpWidgetAndSettle(
      ProviderScope(
        overrides: overrides ?? [],
        child: const MyApp(),
      ),
    );
  }

  Future<void> verifyPIN(String email) async {
    expect($('Verify PIN'), findsWidgets);

    final pinCode = await TestHelper().getEmailOTP(email);
    await $(K.authVerifyFormPinput).enterText(pinCode);
  }

  Future<void> goBack() async {
    await $.tester.pageBack();
    await $.pumpAndSettle();
  }
}
