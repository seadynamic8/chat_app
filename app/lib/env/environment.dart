import 'package:chat_app/env/env.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'environment.g.dart';

class Environment {
  Environment({required this.ref});

  final Ref ref;

  // This is ugly code, but for now, there's no easy work-around.
  // For some reason, the Env generator can't generate more than 2 versions of
  // the Env class, so you could do EnvDev and EnvStage, but not EnvProd.
  // When you try the 3rd class, the key will fail.
  (String, String) getSupabaseUrlAndKey() {
    final env = ref.read(envProvider);

    late String supabaseUrl;
    late String supabaseKey;

    const currentEnv = String.fromEnvironment('ENV');

    logger.i('Current Env: $currentEnv');

    switch (currentEnv) {
      case 'PROD' || 'prod' || 'production':
        supabaseUrl = env.prodSupabaseUrl;
        supabaseKey = env.prodSupabaseKey;
      case 'STAG' || 'STAGE' || 'stag' || 'stage' || 'staging':
        supabaseUrl = env.stageSupabaseUrl;
        supabaseKey = env.stageSupabaseKey;
      case 'DEV' || 'dev' || 'development':
      default:
        supabaseUrl = env.devSupabaseUrl;
        supabaseKey = env.devSupabaseKey;
    }
    return (supabaseUrl, supabaseKey);
  }
}

@riverpod
Environment environment(EnvironmentRef ref) {
  return Environment(ref: ref);
}

@riverpod
Env env(EnvRef ref) {
  const key = String.fromEnvironment('ENCRYPTION_KEY');
  const iv = String.fromEnvironment('IV');
  return const Env(key, iv);
}
