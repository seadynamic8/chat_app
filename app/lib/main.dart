import 'package:auto_route/auto_route.dart';
import 'package:chat_app/env/environment.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/data/current_profile_provider.dart';
import 'package:chat_app/i18n/supported_locales_and_delegates.dart';
import 'package:chat_app/routing/routing_observer.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final environment = ProviderContainer().read(environmentProvider);
  final (supabaseUrl, supabaseKey) = environment.getSupabaseUrlAndKey();

  logger.t('supabaseUrl: $supabaseUrl');

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
    authFlowType: AuthFlowType.pkce,
    realtimeClientOptions:
        const RealtimeClientOptions(eventsPerSecond: 2), // Default is 10
  );

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  ); // To turn off landscape mode for now

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);

    // Will be null at first (after login, the language will be set)
    final currentLocale = ref.watch(currentProfileProvider).language;

    return MaterialApp.router(
      title: 'Chat With Friends',
      darkTheme:
          ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark()),
      themeMode: ThemeMode.dark,
      routerConfig: appRouter.config(
        reevaluateListenable: ReevaluateListenable.stream(
          ref.watch(authRepositoryProvider).onAuthStateChanges(),
        ),
        navigatorObservers: () => [ref.read(routingObserverProvider)],
      ),
      localizationsDelegates: localizationDelegates,
      supportedLocales: supportedLocales,
      locale: currentLocale,
    );
  }
}
