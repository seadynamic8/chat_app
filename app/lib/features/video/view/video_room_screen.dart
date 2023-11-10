import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/home/domain/call_request_state.dart';
import 'package:chat_app/features/home/view/call_request_controller.dart';
import 'package:chat_app/features/video/view/local_tile.dart';
import 'package:chat_app/features/video/view/remote_tile.dart';
import 'package:chat_app/features/video/view/video_controls.dart';
import 'package:chat_app/features/video/view/video_room_controller.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class VideoRoomScreen extends ConsumerWidget {
  const VideoRoomScreen({
    super.key,
    required this.videoRoomId,
    required this.otherProfile,
  });

  final String videoRoomId;
  final Profile otherProfile;

  void _leaveVideoRoom(BuildContext context) {
    logger.i('leaving video room');
    context.router.pop();
  }

  void _endCall(BuildContext context, WidgetRef ref) async {
    logger.i('click end video call');

    ref
        .read(callRequestControllerProvider.notifier)
        .sendEndCall(videoRoomId, otherProfile);

    try {
      ref.read(videoRoomControllerProvider.notifier).endCall();
    } catch (error) {
      // Sometimes we try to end the call when the remote hasn't appeared yet,
      // or they leave too fast, and it gives error because it can't end it.
      logger.w('Error ending call: $error', stackTrace: StackTrace.current);
    }

    _leaveVideoRoom(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<CallRequestState>(callRequestControllerProvider, (_, state) {
      if (state.callType == CallRequestType.endCall) {
        ref.read(callRequestControllerProvider.notifier).resetToWaiting();

        _leaveVideoRoom(context);
      }
    });

    final stateValue = ref.watch(videoRoomControllerProvider);

    return I18n(
      child: SafeArea(
        child: Scaffold(
          body: AsyncValueWidget(
            value: stateValue,
            data: (state) => Stack(
              children: [
                RemoteTile(
                  isLoading: state.remoteParticipants.isEmpty ||
                      state.remoteParticipants[otherProfile.id] == null,
                  remoteParticipant: state.remoteParticipants[otherProfile.id],
                ),
                Positioned(
                  top: 10,
                  left: 15,
                  child: IconButton(
                    onPressed: () => _endCall(context, ref),
                    color: Colors.white.withAlpha(200),
                    icon: const Icon(
                      Icons.arrow_back,
                      shadows: [
                        Shadow(color: Colors.black, blurRadius: 1),
                      ],
                    ),
                  ),
                ),
                LocalTile(localParticipant: state.localParticipant),
                const Positioned(
                  top: 50,
                  left: 15,
                  child: VideoControls(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
