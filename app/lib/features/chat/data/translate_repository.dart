import 'package:chat_app/env/env.dart';
import 'package:chat_app/env/environment.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/utils/dio_provider.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'translate_repository.g.dart';

const baseUrl = 'https://api.cognitive.microsofttranslator.com';

class TranslateRepository {
  TranslateRepository({required this.env, required this.dio});

  final Env env;
  final Dio dio;

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
      // only use the fromLangCode if detection fails
      'suggestedFrom': fromLangCode,
    };

    final bodyData = [
      {'Text': text}
    ];

    try {
      final response = await dio.post<List<dynamic>>(
        '$baseUrl/translate',
        options: options,
        queryParameters: queryParams,
        data: bodyData,
      );

      // Sample response
      // response: [{translations: [{text: Hola, to: es}]}]

      if (response.data == null) return null;

      final responseData = response.data![0] as Map<String, dynamic>;

      final detectedLang = responseData.containsKey('detectedLanguage')
          ? responseData['detectedLanguage']['language']
          : null;

      final translations = responseData['translations'] as List<dynamic>;
      // We would try to match the 'to' to the langCode, but sometimes they are different.
      // Ex: Ours (no), Theirs (nb)
      // So since we ask for one translation, the first is fine
      final translation = translations[0];

      // Return null if translation Language is the same as the detectedLang
      if (translation['to'] == detectedLang) return null;

      final translatedText = translation['text'] as String;

      // Return null if translation is the same as the orignal text
      if (text == translatedText) return null;

      return translatedText;
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        logger.error('translate(): Data: ${e.response!.data}', e, e.stackTrace);
        logger.error(
            'translate(): Request options: ${e.response!.requestOptions.headers}',
            e,
            e.stackTrace);
      } else {
        logger.error(
            'translate(): Error message: ${e.message}', e, e.stackTrace);
      }
      rethrow;
    } catch (error, st) {
      logger.error('translate()', error, st);
      throw Exception('Unable to translate message'.i18n);
    }
  }
}

@riverpod
TranslateRepository translateRepository(TranslateRepositoryRef ref) {
  final env = ref.watch(envProvider);
  final dio = ref.watch(dioProvider);
  return TranslateRepository(env: env, dio: dio);
}
