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

  // Incoming Messages

  void setIncomingCall(Map<String, dynamic> payload) {
    if (!payload.containsKey('fromId') ||
        !payload.containsKey('fromUsername') ||
        !payload.containsKey('videoRoomId') ||
        payload['fromId'].isEmpty ||
        payload['fromUsername'].isEmpty ||
        payload['videoRoomId'].isEmpty) {
      logger.w('Invalid new_call request!');
      return;
    }

    state = IncomingCallState(
        otherUsername: payload['fromUsername'],
        videoRoomId: payload['videoRoomId'],
        callType: IncomingCallType.newCall);
  }

  void setCancelCall(Map<String, dynamic> payload) {
    state = IncomingCallState(callType: IncomingCallType.cancelCall);
  }

  // Outgoing Messages

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
