import 'dart:convert';

import 'package:chat_app/env/env.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'environment.g.dart';

const encryptionKeyFile = 'assets/config/encryption_key.json';

class EnvRepository {
  // Get Encryption Key from Assets Json File
  static Future<Map<String, dynamic>> getEncryptionKeyFromFile() async {
    final jsonString = await rootBundle.loadString(encryptionKeyFile);
    final jsonData = jsonDecode(jsonString);

    return jsonData as Map<String, dynamic>;
  }

  static Future<Env> getEnv() async {
    final json = await getEncryptionKeyFromFile();

    return Env(
      json['ENCRYPTION_KEY'] as String,
      json['IV'] as String,
    );
  }
}

// Create a dummy provider to be overrriden in mart.dart
// - Because we want an initialized provider, not a future provider, so we need
// to await for the value before the app starts and then reassign in to this
// provider.
@Riverpod(keepAlive: true)
Env env(EnvRef ref) {
  return throw UnimplementedError();
}
