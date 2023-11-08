import 'package:chat_app/features/home/application/online_presences.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/video/view/waiting_screen_controller.dart';
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
  void initiateCall(String videoRoomId) async {
    final router = context.router;

    await ref
        .read(onlinePresencesProvider.notifier)
        .updateCurrentUserPresence(OnlineStatus.busy);

    router.replace(VideoRoomRoute(videoRoomId: videoRoomId));
  }

  void cancelWait() {
    context.router.pop();
  }

  void _cancelCall() async {
    await ref
        .read(waitingScreenControllerProvider(
                widget.otherProfile, initiateCall, cancelWait)
            .notifier)
        .sendCancelCall();

    cancelWait();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(waitingScreenControllerProvider(
        widget.otherProfile, initiateCall, cancelWait));

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
