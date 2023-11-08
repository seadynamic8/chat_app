import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/home/application/online_presences.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:chat_app/features/video/view/local_tile.dart';
import 'package:chat_app/features/video/view/remote_tile.dart';
import 'package:chat_app/features/video/view/video_controls.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:videosdk/videosdk.dart';

@RoutePage()
class VideoRoomScreen extends ConsumerWidget {
  const VideoRoomScreen({super.key, required this.videoRoomId});

  final String videoRoomId;

  void _endCall(BuildContext context, WidgetRef ref) async {
    logger.i('ending call, leaving room');

    final router = context.router;
    // ref.read(videoRoomProvider.notifier).leaveRoom();

    await ref
        .read(onlinePresencesProvider.notifier)
        .updateCurrentUserPresence(OnlineStatus.online);

    // If was in chat room, go back to chat room (and not waiting room)
    // If was somewhere else, go back there? or root?
    router.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const AsyncValue state = AsyncData(null);
    const List<Participant> remoteParticipants = [];

    return I18n(
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: RemoteTile(
                    isLoading: state.isLoading, remoteParticipants: const []),
              ),
              Positioned(
                top: 10,
                left: 15,
                child: IconButton(
                  onPressed: () => _endCall(context, ref),
                  color: Colors.white.withAlpha(200),
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              // LocalTile(isLoading: state.isLoading, localParticipant: Participant.null)
              Positioned(
                top: 50,
                left: 15,
                child: VideoControls(
                  onEndCall: () => _endCall(context, ref),
                  // onToggleMic: ref.read(videoRoomProvider.notifier).toggleMic,
                  onToggleMic: () {},
                  // TODO : check that other side is disabled too when off
                  // onToggleCamera: ref.read(videoRoomProvider.notifier).toggleCamera,
                  onToggleCamera: () {},
                  // onSwitchNextCamera:
                  // ref.read(videoRoomProvider.notifier).switchNextCamera,
                  onSwitchNextCamera: () {},
                  // allCameras: [],
                  // selectedCameraDeviceId: _room.selectedCamId,
                  // onChangeCamera: (deviceId) => _room.changeCam(deviceId),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
