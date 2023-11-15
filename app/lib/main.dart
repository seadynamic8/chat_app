import 'package:auto_route/auto_route.dart';
import 'package:chat_app/env/environment.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/application/app_locale_provider.dart';
import 'package:chat_app/i18n/supported_locales_and_delegates.dart';
import 'package:chat_app/routing/routing_observer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final env = await EnvRepository.getEnv();

  final container = ProviderContainer(overrides: [
    envProvider.overrideWithValue(env),
  ]);

  await Supabase.initialize(
    url: env.supabaseUrl,
    anonKey: env.supabaseKey,
    authFlowType: AuthFlowType.pkce,
    realtimeClientOptions: const RealtimeClientOptions(eventsPerSecond: 2),
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);
    final currentLocale = ref.watch(appLocaleProvider);

    return MaterialApp.router(
      title: 'Chat With Friends',
      darkTheme: ThemeData.dark()
          .copyWith(useMaterial3: true, colorScheme: const ColorScheme.dark()),
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
