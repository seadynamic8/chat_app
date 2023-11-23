import 'package:auto_route/auto_route.dart';
import 'package:chat_app/env/environment.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/application/app_locale_provider.dart';
import 'package:chat_app/features/home/application/channel_setup_service.dart';
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

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final AppLifecycleListener _listener;
  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(onStateChange: _onStateChanged);
  }

  void _onStateChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        logger.i('appState: paused');
        final css = ref.read(channelSetupServiceProvider);
        css.closeLobbyChannel();
        css.closeUserChannel();
      case AppLifecycleState.resumed:
        logger.i('appState: resumed');
        final css = ref.read(channelSetupServiceProvider);
        css.setupLobbyChannel();
        css.setupUserChannel();
      case AppLifecycleState.inactive:
        logger.t('appState: inactive');
      case AppLifecycleState.detached:
        logger.t('appState: detached');
      case AppLifecycleState.hidden:
        logger.t('appState: hidden');
      default:
    }
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appRouter = ref.watch(appRouterProvider);
    final currentLocale = ref.watch(appLocaleProvider);

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
