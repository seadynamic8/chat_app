import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/home/domain/call_request_state.dart';
import 'package:chat_app/features/home/view/call_request_controller.dart';
import 'package:chat_app/features/video/data/video_timer_provider.dart';
import 'package:chat_app/features/video/view/local_tile.dart';
import 'package:chat_app/features/video/view/remote_badge.dart';
import 'package:chat_app/features/video/view/remote_tile.dart';
import 'package:chat_app/features/video/view/video_back_button.dart';
import 'package:chat_app/features/video/view/video_controls.dart';
import 'package:chat_app/features/video/view/video_room_controller.dart';
import 'package:chat_app/features/video/view/video_stopwatch.dart';
import 'package:chat_app/features/video_chat/view/video_chat_overlay.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

@RoutePage()
class VideoRoomScreen extends ConsumerWidget {
  const VideoRoomScreen({
    super.key,
    required this.videoRoomId,
    required this.otherProfileId,
    this.isCaller = false,
  });

  final String videoRoomId;
  final String otherProfileId;
  final bool isCaller;

  void _endCall(
    BuildContext context,
    WidgetRef ref, {
    bool isLocal = true,
    bool trialFinished = false,
  }) {
    try {
      if (isLocal) {
        ref
            .read(callRequestControllerProvider.notifier)
            .sendEndCall(videoRoomId, otherProfileId);
      }
      ref
          .read(videoRoomControllerProvider(isCaller).notifier)
          .endCall(trialFinished: trialFinished);
    } catch (error) {
      logger.w('Error ending call: $error', stackTrace: StackTrace.current);
    }
    _leaveVideoRoom(context);
  }

  void _leaveVideoRoom(BuildContext context) {
    WakelockPlus.disable();
    context.router.maybePop();
  }

  void _listenForCallRequestEnd(BuildContext context, WidgetRef ref) {
    ref.listen<CallRequestState>(callRequestControllerProvider, (_, state) {
      if (state.callType == CallRequestType.endCall) {
        ref.read(callRequestControllerProvider.notifier).resetToWaiting();
        _endCall(context, ref, isLocal: false);
      }
    });
  }

  void _listenForTimerEnd(BuildContext context, WidgetRef ref) {
    final timerEnded = ref.watch(videoTimerProvider);
    if (timerEnded) {
      _endCall(context, ref, trialFinished: true);
    }
  }

  void _listenForAppPaused(BuildContext context, WidgetRef ref) {
    ref.listen(
      videoRoomControllerProvider(isCaller),
      (_, state) => state.whenData((videoRoomState) {
        if (videoRoomState.isAppPaused) {
          _endCall(context, ref);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _listenForCallRequestEnd(context, ref);
    if (isCaller) _listenForTimerEnd(context, ref);

    final stateValue = ref.watch(videoRoomControllerProvider(isCaller));
    _listenForAppPaused(context, ref);

    final mediaQuerySize = MediaQuery.sizeOf(context);

    final double localTileWidth = mediaQuerySize.width * 0.30;
    const double localTileTopOffset = 40;
    const double localTileRightOffset = 20;
    final double localTileHeight = mediaQuerySize.height * 0.19;
    const double stopwatchHeight = 20;
    const double backButtonWidth = 48;
    const double backButtonLeftOffset = 15;

    return I18n(
      child: SafeArea(
        child: Scaffold(
          body: KeyboardDismissOnTap(
            child: KeyboardVisibilityProvider(
              child: AsyncValueWidget(
                value: stateValue,
                data: (state) => Stack(
                  children: [
                    RemoteTile(
                      isLoading: !state.remoteJoined ||
                          state.remoteParticipants[otherProfileId] == null,
                      remoteParticipant:
                          state.remoteParticipants[otherProfileId],
                    ),
                    Positioned(
                      top: localTileTopOffset + localTileHeight,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: VideoChatOverlay(
                        isRemoteReady: state.remoteJoined &&
                            state.remoteParticipants[otherProfileId] != null,
                        otherProfileId: otherProfileId,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: backButtonLeftOffset,
                      right: localTileWidth + localTileRightOffset,
                      child: Row(
                        children: [
                          // BACK BUTTON
                          VideoBackButton(
                            width: backButtonWidth,
                            onPressEndCall: () => _endCall(context, ref),
                          ),

                          IntrinsicWidth(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: mediaQuerySize.width -
                                    backButtonLeftOffset -
                                    backButtonWidth -
                                    localTileWidth -
                                    localTileRightOffset,
                              ),
                              child:
                                  RemoteBadge(otherProfileId: otherProfileId),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: localTileTopOffset,
                      right: localTileRightOffset,
                      child: LocalTile(
                        localParticipant: state.localParticipant,
                        height: localTileHeight,
                        width: localTileWidth,
                      ),
                    ),
                    Positioned(
                      top: localTileTopOffset +
                          localTileHeight -
                          stopwatchHeight,
                      right: localTileRightOffset,
                      child: const VideoStopwatch(height: stopwatchHeight),
                    ),
                    const Positioned(
                      top: 50,
                      left: backButtonLeftOffset,
                      child: VideoControls(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
