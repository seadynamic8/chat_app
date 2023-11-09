import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/application/online_presences.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/home/data/channel_presence_handlers.dart';
import 'package:chat_app/features/home/data/channel_repository.dart';
import 'package:chat_app/features/home/domain/call_request_state.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'call_request_controller.g.dart';

@Riverpod(keepAlive: true)
class CallRequestController extends _$CallRequestController {
  @override
  CallRequestState build() {
    return CallRequestState();
  }

  void resetToWaiting() {
    state = CallRequestState(callType: CallRequestType.waiting);
  }

  // * Incoming Messages

  // Callee receive

  void onNewCall(Map<String, dynamic> payload) {
    // TODO: maybe handle in the view?
    if (!payload.containsKey('fromUserId') ||
        !payload.containsKey('fromUsername') ||
        !payload.containsKey('videoRoomId') ||
        payload['fromUserId'].isEmpty ||
        payload['fromUsername'].isEmpty ||
        payload['videoRoomId'].isEmpty) {
      logger.w('Invalid new_call request!');
      return;
    }

    state = CallRequestState(
      callType: CallRequestType.newCall,
      otherUserId: payload['fromUserId'],
      otherUsername: payload['fromUsername'],
      videoRoomId: payload['videoRoomId'],
    );
  }

  void onCancelCall(Map<String, dynamic> payload) {
    state = CallRequestState(callType: CallRequestType.cancelCall);
  }

  // Caller receive

  void onAcceptCall(Map<String, dynamic> payload) async {
    if (!payload.containsKey('videoRoomId') || payload['videoRoomId'].isEmpty) {
      logger.w('Invalid accept_call message!');
      return;
    }
    state = CallRequestState(
      callType: CallRequestType.acceptCall,
      videoRoomId: payload['videoRoomId'],
    );
  }

  void onRejectCall(Map<String, dynamic> payload) async {
    await ref
        .read(onlinePresencesProvider.notifier)
        .updateCurrentUserPresence(OnlineStatus.online);

    state = CallRequestState(callType: CallRequestType.rejectCall);
  }

  void onEndCall(Map<String, dynamic> payload) async {
    await ref
        .read(onlinePresencesProvider.notifier)
        .updateCurrentUserPresence(OnlineStatus.online);

    state = CallRequestState(callType: CallRequestType.endCall);
  }

  // * Outgoing Messages

  // From Caller

  Future<void> sendNewCall(String videoRoomId, Profile otherProfile) async {
    createChatMessageForVideoStatus(VideoStatus.started, otherProfile.id);

    final currentProfile =
        await ref.watch(authRepositoryProvider).currentProfile;
    await _sendMessageToOtherUser(
      channelName: otherProfile.username!,
      event: 'new_call',
      payload: {
        'fromUserId': currentProfile.id,
        'fromUsername': currentProfile.username,
        'videoRoomId': videoRoomId,
      },
    );
  }

  Future<void> sendCancelCall(Profile otherProfile) async {
    await ref
        .read(onlinePresencesProvider.notifier)
        .updateCurrentUserPresence(OnlineStatus.online);

    createChatMessageForVideoStatus(VideoStatus.cancelled, otherProfile.id);

    final currentProfile =
        await ref.watch(authRepositoryProvider).currentProfile;
    await _sendMessageToOtherUser(
      channelName: otherProfile.username!,
      event: 'cancel_call',
      payload: {
        'fromUsername': currentProfile.username,
      },
    );
  }

  // From Callee

  void sendAcceptCall() async {
    await _sendMessageToOtherUser(
      channelName: state.otherUsername!,
      event: 'accept_call',
      payload: {'videoRoomId': state.videoRoomId!},
    );
    resetToWaiting();
  }

  void sendRejectCall() async {
    // This chat message needs to be done before the send message or else the
    // state gets cleared for some reason?
    createChatMessageForVideoStatus(VideoStatus.rejected, state.otherUserId!);

    await _sendMessageToOtherUser(
        channelName: state.otherUsername!, event: 'reject_call');

    resetToWaiting();
  }

  // From Call Ender

  void sendEndCall(String videoRoomId, Profile otherProfile) async {
    await ref
        .read(onlinePresencesProvider.notifier)
        .updateCurrentUserPresence(OnlineStatus.online);

    await ref
        .read(callRequestControllerProvider.notifier)
        .createChatMessageForVideoStatus(VideoStatus.ended, otherProfile.id);

    await _sendMessageToOtherUser(
      channelName: otherProfile.username!,
      event: 'end_call',
      payload: {'videoRoomId': videoRoomId},
    );
  }

  Future<void> _sendMessageToOtherUser({
    required String channelName,
    required String event,
    Map<String, dynamic>? payload,
  }) async {
    final otherUserChannel = ref.watch(channelRepositoryProvider(channelName));
    await otherUserChannel.subscribed();

    await Future.delayed(const Duration(milliseconds: 1000));

    otherUserChannel.send(event, payload: payload);

    otherUserChannel.close();
    // For some reason, even if we do this, channel repository comes back
    // Maybe because of keep alive, but what's invalidate for then?
    ref.invalidate(channelRepositoryProvider(channelName));
  }

  Future<void> createChatMessageForVideoStatus(
    VideoStatus status,
    String otherProfileId,
  ) async {
    final currentProfile =
        await ref.watch(authRepositoryProvider).currentProfile;
    final chatRoom = await ref.read(chatRepositoryProvider).findRoomByProfiles(
          currentProfileId: currentProfile.id,
          otherProfileId: otherProfileId,
        );
    ref.read(chatRepositoryProvider).updateVideoStatus(
          status: status,
          roomId: chatRoom!.id,
          currentProfileId: currentProfile.id,
        );
  }
}
