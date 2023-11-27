import 'package:chat_app/utils/logger.dart';
import 'package:dio/dio.dart';

class EmailApi {
  final dio = Dio();

  Future<String> getLastEmailId(String mailboxName) async {
    late Response<List<dynamic>> response;

    final url = 'http://192.168.1.25:54324/api/v1/mailbox/$mailboxName';
    try {
      response = await dio.get<List<dynamic>>(url);
    } on DioException catch (e) {
      if (e.response != null) {
        logger.e('EmailApi Error Data: ${e.response!.data}');
        logger.e(
            'EmailApi Error request options: ${e.response!.requestOptions.headers}');
      } else {
        logger.e('EmailApi Error message: ${e.message}',
            stackTrace: e.stackTrace);
      }
      throw Exception('EmailApi: Failed: ${e.message}');
    }

    final responseData = response.data as List<dynamic>;
    final firstEmail = responseData.last as Map<String, dynamic>;
    return firstEmail['id'] as String;
  }

  Future<String> getCodeFromEmail(String mailboxName, String emailId) async {
    late Response<Map<String, dynamic>> response;

    final emailUrl =
        'http://192.168.1.25:54324/api/v1/mailbox/$mailboxName/$emailId';

    try {
      response = await dio.get<Map<String, dynamic>>(emailUrl);
    } on DioException catch (e) {
      if (e.response != null) {
        logger.e('EmailApi Error Data: ${e.response!.data}');
        logger.e(
            'EmailApi Error request options: ${e.response!.requestOptions.headers}');
      } else {
        logger.e('EmailApi Error message: ${e.message}',
            stackTrace: e.stackTrace);
      }
      throw Exception('EmailApi: Failed: ${e.message}');
    }

    final emailResponseData = response.data as Map<String, dynamic>;
    final emailResponseBody = emailResponseData['body'] as Map<String, dynamic>;
    final emailResponseText = emailResponseBody['text'] as String;

    final codeIndex = emailResponseText.indexOf('code:');
    const codeDescLength = 6;
    const codeLength = 6;
    return emailResponseText.substring(
        codeIndex + codeDescLength, codeIndex + codeDescLength + codeLength);
  }
}
