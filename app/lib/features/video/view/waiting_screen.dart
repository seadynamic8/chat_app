import 'package:chat_app/features/home/domain/call_request_state.dart';
import 'package:chat_app/features/home/view/call_request_controller.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class WaitingScreen extends ConsumerStatefulWidget {
  const WaitingScreen({super.key, required this.otherProfile});

  final Profile otherProfile;

  @override
  ConsumerState<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends ConsumerState<WaitingScreen> {
  void _cancelWait() {
    context.router.pop();
  }

  void _cancelCall() async {
    await ref.read(callRequestControllerProvider.notifier).sendCancelCall();
    _cancelWait();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<CallRequestState>(callRequestControllerProvider, (_, state) {
      switch (state.callType) {
        case CallRequestType.acceptCall:
          // Use 'replace' here so that users wont' return here after the call.
          context.router.replace(VideoRoomRoute(
            videoRoomId: state.videoRoomId!,
            otherProfile: widget.otherProfile,
          ));
        case CallRequestType.rejectCall:
          ref.read(callRequestControllerProvider.notifier).resetToWaiting();
          _cancelWait();
        default:
      }
    });

    return I18n(
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: const AssetImage(defaultAvatarImage),
                  foregroundImage: widget.otherProfile.avatarUrl == null
                      ? null
                      : NetworkImage(widget.otherProfile.avatarUrl!),
                  radius: 70,
                ),
                const SizedBox(height: 15),
                Text(
                  'Wating for ${widget.otherProfile.username ?? 'User'} ...',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _cancelCall,
                  child: const Text('Cancel Call'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
