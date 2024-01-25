import 'package:chat_app/features/video/data/video_repository.dart';
import 'package:chat_app/features/video/data/video_settings_provider.dart';
import 'package:chat_app/features/video_chat/domain/video_chat_message.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:videosdk/videosdk.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_chat_repository.g.dart';

class VideoChatRepository {
  VideoChatRepository({required this.videoRoom, required this.videoRoomId});

  final Room videoRoom;
  final String videoRoomId;

  Future<void> send({
    required String message,
    Map<String, dynamic> payload = const {},
  }) async {
    try {
      videoRoom.pubSub.publish(
        videoRoomId,
        message,
        // Option to persist messages for later participants
        const PubSubPublishOptions(persist: true),
        payload,
      );
    } catch (error, st) {
      logger.error('send()', error, st);
      throw Exception('Something went wrong with sending message'.i18n);
    }
  }

  Future<void> subscribe(
    dynamic Function(VideoChatMessage videoChatMessage) callback,
  ) async {
    try {
      videoRoom.pubSub.subscribe(videoRoomId, (PubSubMessage psMessage) {
        callback(VideoChatMessage(psMessage: psMessage));
      });
    } catch (error, st) {
      logger.error('subscribe()', error, st);
    }
  }

  Future<void> unsubscribe(
    dynamic Function(VideoChatMessage videoChatMessage) callback,
  ) async {
    try {
      videoRoom.pubSub.unsubscribe(videoRoomId, (PubSubMessage psMessage) {
        callback(VideoChatMessage(psMessage: psMessage));
      });
    } catch (error, st) {
      logger.error('unsubscribe()', error, st);
    }
  }
}

@riverpod
FutureOr<VideoChatRepository> videoChatRepository(
    VideoChatRepositoryRef ref) async {
  final videoRepository = await ref.watch(videoRepositoryProvider.future);
  final videoRoomId = ref.watch(videoSettingsProvider).roomId!;
  return VideoChatRepository(
      videoRoom: videoRepository.videoRoom, videoRoomId: videoRoomId);
}
