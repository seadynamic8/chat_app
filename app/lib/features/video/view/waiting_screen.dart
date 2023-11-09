import 'package:chat_app/features/home/domain/call_request_state.dart';
import 'package:chat_app/features/home/view/call_request_controller.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class WaitingScreen extends ConsumerStatefulWidget {
  const WaitingScreen(
      {super.key, required this.videoRoomId, required this.otherProfile});

  final String videoRoomId;
  final Profile otherProfile;

  @override
  ConsumerState<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends ConsumerState<WaitingScreen> {
  void _cancelWait() {
    context.router.pop();
  }

  void _cancelCall() async {
    await ref
        .read(callRequestControllerProvider.notifier)
        .sendCancelCall(widget.otherProfile);

    _cancelWait();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<CallRequestState>(callRequestControllerProvider, (_, state) {
      switch (state.callType) {
        case CallRequestType.acceptCall:
          context.router.replace(VideoRoomRoute(
            videoRoomId: widget.videoRoomId,
            otherProfile: widget.otherProfile,
          ));
        case CallRequestType.rejectCall:
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
                  backgroundImage: AssetImage(widget.otherProfile.avatarUrl ??
                      'assets/images/user_default_image.png'),
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
