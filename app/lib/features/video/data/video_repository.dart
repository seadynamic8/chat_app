import 'package:chat_app/utils/dio_provider.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_repository.g.dart';

class VideoRepository {
  VideoRepository({required this.dio});

  final Dio dio;

  Future<String?> getRoomId(String token) async {
    logger.t('getting room id....');

    final headers = {'Authorization': token};

    final options = Options(
      sendTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: headers,
    );

    late Response<Map<String, dynamic>> response;

    try {
      response = await dio.post<Map<String, dynamic>>(
        'https://api.videosdk.live/v2/rooms',
        options: options,
      );
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        logger.e('Error Data: ${e.response!.data}');
      } else {
        logger.e('Error message: ${e.message}', stackTrace: e.stackTrace);
      }
    }

    return response.data!['roomId'] as String;
  }
}

@riverpod
VideoRepository videoRepository(VideoRepositoryRef ref) {
  final dio = ref.watch(dioProvider);
  return VideoRepository(dio: dio);
}
