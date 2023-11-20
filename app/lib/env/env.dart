import 'package:secure_dotenv/secure_dotenv.dart';

part 'env.g.dart';

@DotEnvGen(filename: '.env')
abstract class Env {
  const Env._();

  const factory Env(String encryptionKey, String iv) = _$Env;

  String get devSupabaseUrl;
  String get devSupabaseKey;

  String get stageSupabaseUrl;
  String get stageSupabaseKey;

  String get prodSupabaseUrl;
  String get prodSupabaseKey;

  String get azureKey;
  String get azureRegion;
}
