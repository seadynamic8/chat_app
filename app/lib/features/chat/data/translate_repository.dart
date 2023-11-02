import 'package:chat_app/env/env.dart';
import 'package:chat_app/env/environment.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'translate_repository.g.dart';

const baseUrl = 'https://api.cognitive.microsofttranslator.com';

class TranslateRepository {
  TranslateRepository({required this.env});

  final Env env;
  final dio = Dio();

  Future<String?> translate({
    required String text,
    required String toLangCode,
    String? fromLangCode,
  }) async {
    final headers = {
      'Ocp-Apim-Subscription-Key': env.azureKey,
      'Ocp-Apim-Subscription-Region': env.azureRegion,
      'Content-type': 'application/json; charset=UTF-8',
    };

    final options = Options(
      sendTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: headers,
    );

    final queryParams = {
      'api-version': '3.0',
      'to': toLangCode,
      'from': fromLangCode,
    };

    final bodyData = [
      {'Text': text}
    ];

    final response = await dio.post<List<dynamic>>(
      '$baseUrl/translate',
      options: options,
      queryParameters: queryParams,
      data: bodyData,
    );

    // Sample response
    // response: [{translations: [{text: Hola, to: es}]}]

    if (response.data == null) return null;

    final translations = response.data![0]['translations'] as List<dynamic>;
    final translation =
        translations.firstWhere((t) => t['to'] == toLangCode)['text'];

    return translation as String;
  }
}

@riverpod
TranslateRepository translateRepository(TranslateRepositoryRef ref) {
  final env = ref.watch(envProvider);
  return TranslateRepository(env: env);
}
