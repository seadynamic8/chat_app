import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/data/channel_repository.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tabs_navigation_controller.g.dart';

@riverpod
class TabsNavigationController extends _$TabsNavigationController {
  @override
  void build(
    void Function(String otherUsername, String videoRoomId) showBanner,
    void Function() closeBanner,
  ) async {
    logger.t('TabsNavigationState init()');

    // Join own channel
    final currentUserName = ref.watch(authRepositoryProvider).currentUserName!;

    // Since we "keep alive" this repository, we don't want to resubscribe
    // or re-add initial handlers if this page controller reloads.
    if (!ref.exists(channelRepositoryProvider(currentUserName))) {
      final myChannel = ref.watch(channelRepositoryProvider(currentUserName));
      await myChannel.subscribed();

      // Interesting, here, don't need to delay after subscribe to add callback handlers

      myChannel.on('new_call', _newCallCallback);
      myChannel.on('cancel_call', _cancelCallCallback);
    }

    ref.onDispose(() {
      logger.t('TabsNavigationState dispose()');
    });
  }

  void sendAcceptCall(String otherUsername, String videoRoomId) async {
    await _sendMessageToOtherUser(
      channelName: otherUsername,
      event: 'accept_call',
      payload: {'videoRoomId': videoRoomId},
    );
    // TODO: Need to save new message that call was started.
  }

  void sendRejectCall(String otherUsername) async {
    await _sendMessageToOtherUser(
        channelName: otherUsername, event: 'reject_call');
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

  // * Callback Handlers

  void _newCallCallback(Map<String, dynamic> payload) async {
    if (!payload.containsKey('fromId') ||
        !payload.containsKey('fromUsername') ||
        !payload.containsKey('videoRoomId') ||
        payload['fromId'].isEmpty ||
        payload['fromUsername'].isEmpty ||
        payload['videoRoomId'].isEmpty) {
      logger.w('Invalid new_call request!');
      return;
    }

    showBanner(payload['fromUsername'], payload['videoRoomId']);
  }

  void _cancelCallCallback(Map<String, dynamic> payload) async {
    closeBanner();
  }
}
