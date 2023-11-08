import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/data/channel_presence_handlers.dart';
import 'package:chat_app/features/home/data/channel_repository.dart';
import 'package:chat_app/features/home/domain/incoming_call_state.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'incoming_call_controller.g.dart';

@Riverpod(keepAlive: true)
class IncomingCallController extends _$IncomingCallController {
  @override
  IncomingCallState build() {
    return IncomingCallState();
  }

  void resetToWaiting() {
    state = IncomingCallState(callType: IncomingCallType.waiting);
  }

  // * Incoming Messages

  // Callee receive

  void onNewCall(Map<String, dynamic> payload) {
    // TODO: maybe handle in the view?
    if (!payload.containsKey('fromUsername') ||
        !payload.containsKey('videoRoomId') ||
        payload['fromUsername'].isEmpty ||
        payload['videoRoomId'].isEmpty) {
      logger.w('Invalid new_call request!');
      return;
    }

    state = IncomingCallState(
      callType: IncomingCallType.newCall,
      otherUsername: payload['fromUsername'],
      videoRoomId: payload['videoRoomId'],
    );
  }

  void onCancelCall(Map<String, dynamic> payload) {
    state = IncomingCallState(callType: IncomingCallType.cancelCall);
  }

  // Caller receive

  void onAcceptCall(Map<String, dynamic> payload) async {
    if (!payload.containsKey('videoRoomId') || payload['videoRoomId'].isEmpty) {
      logger.w('Invalid accept_call message!');
      return;
    }
    state = IncomingCallState(
      callType: IncomingCallType.acceptCall,
      videoRoomId: payload['videoRoomId'],
    );
  }

  void onRejectCall(Map<String, dynamic> payload) async {
    state = IncomingCallState(callType: IncomingCallType.rejectCall);
  }

  // * Outgoing Messages

  // From Caller

  Future<void> sendNewCall(String videoRoomId, String channelName) async {
    final currentProfile =
        await ref.watch(authRepositoryProvider).currentProfile;
    await _sendMessageToOtherUser(
      channelName: channelName,
      event: 'new_call',
      payload: {
        'fromUsername': currentProfile.username,
        'videoRoomId': videoRoomId,
      },
    );
    resetToWaiting();
  }

  Future<void> sendCancelCall(String channelName) async {
    final currentProfile =
        await ref.watch(authRepositoryProvider).currentProfile;
    await _sendMessageToOtherUser(
      channelName: channelName,
      event: 'cancel_call',
      payload: {
        'fromUsername': currentProfile.username,
      },
    );

    // Add a little delay and send again just to make sure the other user
    // receives it.
    await Future.delayed(const Duration(milliseconds: 300));

    await _sendMessageToOtherUser(
      channelName: channelName,
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
    // TODO: Need to save new message that call was started.
  }

  void sendRejectCall() async {
    await _sendMessageToOtherUser(
        channelName: state.otherUsername!, event: 'reject_call');
    resetToWaiting();
    // TODO: Need to save a new message that call was rejected and therefore missed.
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
}
