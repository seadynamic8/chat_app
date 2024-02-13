import 'package:chat_app/env/environment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppInitializer {
  Future<void> setup() async {
    final environment = ProviderContainer().read(environmentProvider);
    final (supabaseUrl, supabaseKey) = environment.getSupabaseUrlAndKey();

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
      realtimeClientOptions: const RealtimeClientOptions(eventsPerSecond: 2),
    );
  }
}
