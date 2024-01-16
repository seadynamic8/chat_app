import 'package:chat_app/env/env.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'environment.g.dart';

enum EnvType { development, staging, production }

class Environment {
  Environment({required this.env});

  final Env env;

  EnvType get envType {
    const currentEnv = String.fromEnvironment('ENV');

    return switch (currentEnv) {
      'PROD' || 'prod' || 'production' => EnvType.production,
      'STAG' || 'STAGE' || 'stag' || 'stage' || 'staging' => EnvType.staging,
      'DEV' || 'dev' || 'development' => EnvType.development,
      _ => EnvType.development,
    };
  }

  String get sentryDsn => env.sentryDsn;

  // This is ugly code, but for now, there's no easy work-around.
  // For some reason, the Env generator can't generate more than 2 versions of
  // the Env class, so you could do EnvDev and EnvStage, but not EnvProd.
  // When you try the 3rd class, the key will fail.
  (String, String) getSupabaseUrlAndKey() {
    late String supabaseUrl;
    late String supabaseKey;

    switch (envType) {
      case EnvType.production:
        supabaseUrl = env.prodSupabaseUrl;
        supabaseKey = env.prodSupabaseKey;
      case EnvType.staging:
        supabaseUrl = env.stageSupabaseUrl;
        supabaseKey = env.stageSupabaseKey;
      case EnvType.development:
      default:
        supabaseUrl = env.devSupabaseUrl;
        supabaseKey = env.devSupabaseKey;
    }
    return (supabaseUrl, supabaseKey);
  }
}

@riverpod
Environment environment(EnvironmentRef ref) {
  final env = ref.read(envProvider);
  return Environment(env: env);
}

@riverpod
Env env(EnvRef ref) {
  const key = String.fromEnvironment('ENCRYPTION_KEY');
  const iv = String.fromEnvironment('IV');
  return const Env(key, iv);
}
