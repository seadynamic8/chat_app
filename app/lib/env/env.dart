import 'package:secure_dotenv/secure_dotenv.dart';

part 'env.g.dart';

@DotEnvGen(filename: '.env.dev')
abstract class Env {
  const Env._();

  const factory Env(String encryptionKey, String iv) = _$Env;

  String get supabaseUrl;
  String get supabaseKey;
}
