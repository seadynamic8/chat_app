import 'package:auto_route/auto_route.dart';
import 'package:chat_app/env/environment.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: appRouter.config(),
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
