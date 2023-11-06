import 'package:chat_app/env/environment.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/video/data/channel_repository.dart';
import 'package:chat_app/features/video/data/video_repository.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'waiting_screen_controller.g.dart';

@riverpod
class WaitingScreenController extends _$WaitingScreenController {
  @override
  void build(Profile otherProfile, void Function(String roomId) initiateCall,
      void Function() cancelWait) async {
    logger.t('WaitingRoomState init()');

    // Temporarily use a hardcoded environment token
    // TODO: Need to generate token, since temp will expire and insecure
    final token = ref.read(envProvider).videoSdkTokenTemp;

    // Create room id (with token)
    final videoRoomId =
        await ref.watch(videoRepositoryProvider).getRoomId(token);
    if (videoRoomId == null) throw ErrorDescription('Failed to get room id');

    logger.i('videoRoomId: $videoRoomId');

    // Setting up my own handlers
    final currentProfile =
        await ref.watch(authRepositoryProvider).currentProfile;
    final myChannel =
        ref.watch(channelRepositoryProvider(currentProfile.username!));
    // No need to resubscribe, since on login already subscribed, just pulling
    // my channel from cache.
    myChannel.on('accept_call', _acceptCallCallback);
    myChannel.on('reject_call', _rejectCallCallback);

    // Join other user channel
    final otherUserChannel =
        ref.watch(channelRepositoryProvider(otherProfile.username!));
    await otherUserChannel.subscribed();

    // Minium delay that I found worked is 500, not sure why the subscription
    // callback doesn't mean it's ready
    await Future.delayed(const Duration(milliseconds: 1000));

    otherUserChannel.send('new_call', payload: {
      'fromId': currentProfile.id,
      'fromUsername': currentProfile.username,
      'videoRoomId': videoRoomId,
    });

    ref.onDispose(() {
      logger.t('WaitingRoomState dispose()');

      myChannel.off('accept_call');
      myChannel.off('reject_call');
      otherUserChannel.close();
      ref.invalidate(channelRepositoryProvider(otherProfile.username!));
    });
  }

  Future<void> sendCancelCall() async {
    final currentProfile =
        await ref.watch(authRepositoryProvider).currentProfile;
    final otherUserChannel =
        ref.watch(channelRepositoryProvider(otherProfile.username!));

    otherUserChannel.send('cancel_call', payload: {
      'fromUsername': currentProfile.username,
    });
  }

  // * Callback Handlers

  void _acceptCallCallback(Map<String, dynamic> payload) async {
    if (!payload.containsKey('videoRoomId') || payload['videoRoomId'].isEmpty) {
      logger.w('Invalid accept_call message!');
      return;
    }
    initiateCall(payload['videoRoomId']);
  }

  void _rejectCallCallback(Map<String, dynamic> payload) async {
    cancelWait();
  }
}
