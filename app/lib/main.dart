import 'package:auto_route/auto_route.dart';
import 'package:chat_app/env/environment.dart';
import 'package:chat_app/i18n/supported_locales.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  final env = await container.read(envProvider.future);

  await Supabase.initialize(
    url: env.supabaseUrl,
    anonKey: env.supabaseKey,
    authFlowType: AuthFlowType.pkce,
    realtimeClientOptions: const RealtimeClientOptions(eventsPerSecond: 2),
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Chat With Friends',
      darkTheme: ThemeData.dark()
          .copyWith(useMaterial3: true, colorScheme: const ColorScheme.dark()),
      themeMode: ThemeMode.dark,
      routerConfig: appRouter.config(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
      // *** Change Locale to different to see different language (ex: Locale('es'))
      // *** Current Locale... can use a button to change if u want
      // *** or remove to use system locale (meaning will change with user region)
      locale: const Locale('en'),
    );
  }
}

@RoutePage()
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
