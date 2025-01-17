import 'package:auto_route/auto_route.dart';
import 'package:chat_app/env/environment.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/view/auth/auth_form_state.dart';
import 'package:chat_app/features/home/application/app_lifecycle_service.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/i18n/supported_locales_and_delegates.dart';
import 'package:chat_app/main_controller.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/routing/routing_observer.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final environment = ProviderContainer().read(environmentProvider);
  final (supabaseUrl, supabaseKey) = environment.getSupabaseUrlAndKey();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
    realtimeClientOptions: const RealtimeClientOptions(
      eventsPerSecond: 10, // Default is 10
    ),
  );

  // Call logger only after initialize Supabase, because it needs it log user
  logger.i('Current Environment: ${environment.envType.name}');
  logger.t('Supabase Url: $supabaseUrl');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  ); // To turn off landscape mode for now

  await SentryFlutter.init(
    (options) {
      options.dsn = kReleaseMode ? environment.sentryDsn : '';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 0.2;
    },
    appRunner: () => runApp(
      const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  void _listenToSignedOutEvent(WidgetRef ref) {
    ref.listen(authStateChangesProvider, (_, state) {
      state.whenData((authState) {
        if (authState.event == AuthChangeEvent.signedOut) {
          _redirectToLoginPage(ref);
        }
      });
    });
  }

  void _redirectToLoginPage(WidgetRef ref) {
    ref.read(appRouterProvider).replaceAll([
      AuthRoute(formType: AuthFormType.login, onAuthResult: (_) => {}),
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);
    ref.watch(loggerRepositoryProvider);

    ref.watch(mainControllerProvider);
    _listenToSignedOutEvent(ref);

    ref.watch(appLifecycleServiceProvider);

    final currentLocale = ref.watch(currentProfileStreamProvider
        .select((value) => value.whenData((profile) => profile?.language)));

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Chat With Friends',
      darkTheme:
          ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark()),
      themeMode: ThemeMode.dark,
      routerConfig: appRouter.config(
        reevaluateListenable: ReevaluateListenable.stream(
          ref.watch(authRepositoryProvider).onAuthStateChanges(),
        ),
        navigatorObservers: () => [
          ref.read(routingObserverProvider),
          TalkerRouteObserver(talker),
        ],
      ),
      localizationsDelegates: localizationDelegates,
      supportedLocales: supportedLocales,
      locale: currentLocale.whenOrNull(data: (currentLocale) => currentLocale),
    );
  }
}
