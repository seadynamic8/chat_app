import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat_lobby/application/chat_lobby_service.dart';
import 'package:chat_app/features/chat_lobby/data/chat_lobby_repository.dart';
import 'package:chat_app/features/home/application/online_presences.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:chat_app/features/home/view/call_request_controller.dart';
import 'package:chat_app/features/video/data/video_api.dart';
import 'package:chat_app/features/video/data/video_settings_provider.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_service.g.dart';

class VideoService {
  VideoService({required this.ref});

  final Ref ref;

  Future<void> makeVideoCall(Profile otherProfile) async {
    final videoRoomId = await _getVideoRoomId();
    if (videoRoomId == null) {
      logger.e('VideoService: videoRoomId is null');
      throw Exception('Something went wrong with video call.'.i18n);
    }
    await _setOnlineStatusToBusy();
    await _ensureChatRoomExists(otherProfile.id!);
    await _sendNewCall(videoRoomId, otherProfile);
  }

  Future<void> createChatMessageForVideoStatus(
    VideoStatus status,
    String otherProfileId,
  ) async {
    final currentProfileId = ref.read(currentUserIdProvider)!;
    final chatRoom =
        await ref.read(findRoomWithUserProvider(otherProfileId).future);

    ref.read(chatRepositoryProvider).updateStatus(
          statusType: MessageType.video.name,
          statusName: status.name,
          roomId: chatRoom!.id,
          profileId: currentProfileId,
        );
  }

  // * Private Methods

  Future<String?> _getVideoRoomId() async {
    try {
      final token = await ref.read(authRepositoryProvider).generateJWTToken();
      final videoRoomId = await ref.read(videoApiProvider).getRoomId(token);

      ref
          .read(videoSettingsProvider.notifier)
          .updateSettings(token: token, roomId: videoRoomId);

      return videoRoomId;
    } catch (error) {
      logger.e(error.toString());
      return null;
    }
  }

  Future<void> _setOnlineStatusToBusy() async {
    await ref
        .read(onlinePresencesProvider.notifier)
        .updateCurrentUserPresence(OnlineStatus.busy);
  }

  Future<void> _sendNewCall(String videoRoomId, Profile otherProfile) async {
    await ref
        .read(callRequestControllerProvider.notifier)
        .sendNewCall(videoRoomId, otherProfile);
  }

  Future<void> _ensureChatRoomExists(String otherProfileId) async {
    // Just don't use the return value
    await ref.read(chatLobbyServiceProvider).findOrCreateRoom(otherProfileId);
  }
}

@riverpod
VideoService videoService(VideoServiceRef ref) {
  return VideoService(ref: ref);
}
