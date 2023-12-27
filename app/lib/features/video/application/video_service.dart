import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
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
    await _sendNewCall(videoRoomId, otherProfile);
  }

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
}

@riverpod
VideoService videoService(VideoServiceRef ref) {
  return VideoService(ref: ref);
}
