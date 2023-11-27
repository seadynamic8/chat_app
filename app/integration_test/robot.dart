import 'package:chat_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:patrol/patrol.dart';

import 'app_initializer.dart';
import 'features/auth/data/email_api.dart';

class Robot {
  Robot({required this.$});

  final PatrolIntegrationTester $;

  Future<void> pumpAndSettleMyApp({bool preSetup = true}) async {
    // Don't need WidgetsFlutterBinding.ensureInitialized() because Patrol does it
    if (preSetup) {
      await AppInitializer().setup();
    }
    await $.pumpWidgetAndSettle(
      const ProviderScope(child: MyApp()),
    );
  }

  Future<String> getEmailOTP(String email) async {
    final mailboxName = email.split('@').first;
    final lastEmailId = await EmailApi().getLastEmailId(mailboxName);
    return await EmailApi().getCodeFromEmail(mailboxName, lastEmailId);
  }
}
