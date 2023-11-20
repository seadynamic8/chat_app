import 'package:chat_app/env/environment.dart';
import 'package:chat_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:patrol/patrol.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Robot {
  Robot({required this.$});

  final PatrolIntegrationTester $;

  Future<void> pumpAndSettleMyApp() async {
    // Don't need WidgetsFlutterBinding.ensureInitialized() because Patrol does it

    final environment = ProviderContainer().read(environmentProvider);
    final (supabaseUrl, supabaseKey) = environment.getSupabaseUrlAndKey();

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
      authFlowType: AuthFlowType.pkce,
      realtimeClientOptions: const RealtimeClientOptions(eventsPerSecond: 2),
    );

    await $.pumpWidgetAndSettle(
      const ProviderScope(child: MyApp()),
    );
  }
}
