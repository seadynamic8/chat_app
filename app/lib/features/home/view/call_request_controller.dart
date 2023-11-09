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
    if (!payload.containsKey('fromUserId') ||
        !payload.containsKey('fromUsername') ||
        !payload.containsKey('videoRoomId') ||
        payload['fromUserId'].isEmpty ||
        payload['fromUsername'].isEmpty ||
        payload['videoRoomId'].isEmpty) {
      logger.w('Invalid new_call request!');
      return;
    }

    state = state.copyWith(
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

    if (!isCorrectUserOrRoom(payload)) return;

    state = state.copyWith(callType: CallRequestType.acceptCall);
  }

  void onRejectCall(Map<String, dynamic> payload) async {
    // Won't check correct user or room here, because for some reason
    // after the accept call, the state gets wiped away.

    await ref
        .read(onlinePresencesProvider.notifier)
        .updateCurrentUserPresence(OnlineStatus.online);

    state = CallRequestState(callType: CallRequestType.rejectCall);
  }

  // Receive From Call Ender

  void onEndCall(Map<String, dynamic> payload) async {
    // Won't check correct user or room here, because for some reason
    // after the send accept call, the state gets wiped away.

    await ref
        .read(onlinePresencesProvider.notifier)
        .updateCurrentUserPresence(OnlineStatus.online);

    state = CallRequestState(callType: CallRequestType.endCall);
  }

  // * Outgoing Messages

  // Caller Send

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

    state = state.copyWith(
      otherUserId: otherProfile.id,
      otherUsername: otherProfile.username,
      videoRoomId: videoRoomId,
    );
  }

  Future<void> sendCancelCall() async {
    await ref
        .read(onlinePresencesProvider.notifier)
        .updateCurrentUserPresence(OnlineStatus.online);

    createChatMessageForVideoStatus(VideoStatus.cancelled, state.otherUserId!);

    final currentProfile =
        await ref.watch(authRepositoryProvider).currentProfile;
    await _sendMessageToOtherUser(
      channelName: state.otherUsername!,
      event: 'cancel_call',
      payload: {
        'fromUsername': currentProfile.username,
      },
    );
    resetToWaiting();
  }

  // Callee Send

  Future<void> sendAcceptCall() async {
    await _sendMessageToOtherUser(
      channelName: state.otherUsername!,
      event: 'accept_call',
      payload: {'videoRoomId': state.videoRoomId!},
    );
  }

  void sendRejectCall() async {
    // Don't need to set online status, since it never changed.

    // This chat message needs to be done before the send message or else the
    // state gets cleared for some reason?
    createChatMessageForVideoStatus(VideoStatus.rejected, state.otherUserId!);

    await _sendMessageToOtherUser(
        channelName: state.otherUsername!, event: 'reject_call');

    resetToWaiting();
  }

  // Call Ender Send

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
    resetToWaiting();
  }

  // * Private Methods

  Future<void> _sendMessageToOtherUser({
    required String channelName,
    required String event,
    Map<String, dynamic>? payload,
  }) async {
    final otherUserChannel = await _getOtherUserChannel(channelName);

    otherUserChannel.send(event, payload: payload);

    otherUserChannel.close();
    // For some reason, even if we do this, channel repository comes back
    // Maybe because of keep alive, but what's invalidate for then?
    ref.invalidate(channelRepositoryProvider(channelName));
  }

  Future<ChannelRepository> _getOtherUserChannel(String channelName) async {
    final otherUserChannel = ref.watch(channelRepositoryProvider(channelName));
    await otherUserChannel.subscribed();

    await Future.delayed(const Duration(milliseconds: 1000));

    return otherUserChannel;
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

  bool isCorrectUserOrRoom(Map<String, dynamic> payload) {
    return payload['videoRoomId'] == state.videoRoomId;
  }
}
