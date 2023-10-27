import 'dart:convert';

import 'package:chat_app/env/env.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

const encryptionKeyFile = 'assets/config/encryption_key.json';

final encryptionKeyProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final jsonString = await rootBundle.loadString(encryptionKeyFile);
  final jsonData = jsonDecode(jsonString);

  return jsonData as Map<String, dynamic>;
});

final envProvider = FutureProvider.autoDispose<Env>((ref) async {
  final json = await ref.read(encryptionKeyProvider.future);

  return Env(
    json['ENCRYPTION_KEY'] as String,
    json['IV'] as String,
  );
});
