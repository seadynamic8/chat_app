import 'package:secure_dotenv/secure_dotenv.dart';

part 'env.g.dart';

@DotEnvGen(filename: '.env.${const String.fromEnvironment('ENV')}')
abstract class Env {
  const Env._();

  const factory Env(String encryptionKey, String iv) = _$Env;
}
