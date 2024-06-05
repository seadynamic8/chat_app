import 'package:chat_app/common/avatar_image.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/domain/call_request_state.dart';
import 'package:chat_app/features/home/view/call_request_controller.dart';
import 'package:chat_app/features/video/view/call_price.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';

@RoutePage()
class WaitingScreen extends ConsumerStatefulWidget {
  const WaitingScreen({super.key, required this.otherProfileId});

  final String otherProfileId;

  @override
  ConsumerState<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends ConsumerState<WaitingScreen> {
  void _cancelWait() {
    context.router.maybePop();
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
            otherProfileId: widget.otherProfileId,
            isCaller: true,
          ));
        case CallRequestType.rejectCall:
          ref.read(callRequestControllerProvider.notifier).resetToWaiting();
          _cancelWait();
        default:
      }
    });

    final otherUsernameValue = ref.watch(
        profileStreamProvider(widget.otherProfileId)
            .select((value) => value.whenData((profile) => profile?.username)));

    return I18n(
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AvatarImage(profileId: widget.otherProfileId, radiusSize: 70),
                const SizedBox(height: 15),
                otherUsernameValue.maybeWhen(
                  data: (otherUsername) => Text(
                    'Wating for ${otherUsername ?? 'User'}',
                    style: Theme.of(context).textTheme.titleLarge!,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  orElse: SizedBox.shrink,
                ),
                const SizedBox(height: 20),
                const CallPrice(),
                const SizedBox(height: 20),
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
