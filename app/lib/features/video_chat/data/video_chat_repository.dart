import 'package:chat_app/features/video/data/video_repository.dart';
import 'package:chat_app/features/video/data/video_settings_provider.dart';
import 'package:chat_app/features/video_chat/domain/video_chat_message.dart';
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
    videoRoom.pubSub.publish(
      videoRoomId,
      message,
      // Option to persist messages for later participants
      const PubSubPublishOptions(persist: true),
      payload,
    );
  }

  Future<void> subscribe(
    dynamic Function(VideoChatMessage videoChatMessage) callback,
  ) async {
    videoRoom.pubSub.subscribe(videoRoomId, (PubSubMessage psMessage) {
      callback(VideoChatMessage(psMessage: psMessage));
    });
  }

  Future<void> unsubscribe(
    dynamic Function(VideoChatMessage videoChatMessage) callback,
  ) async {
    videoRoom.pubSub.unsubscribe(videoRoomId, (PubSubMessage psMessage) {
      callback(VideoChatMessage(psMessage: psMessage));
    });
  }
}

@riverpod
VideoChatRepository videoChatRepository(VideoChatRepositoryRef ref) {
  final videoRepository = ref.watch(videoRepositoryProvider);
  final videoRoomId = ref.watch(videoSettingsProvider).roomId!;
  return VideoChatRepository(
      videoRoom: videoRepository.videoRoom, videoRoomId: videoRoomId);
}
