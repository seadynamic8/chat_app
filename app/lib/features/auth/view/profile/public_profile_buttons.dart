import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/video_call_button.dart';
import 'package:chat_app/features/auth/view/profile/public_profile_buttons_controller.dart';
import 'package:chat_app/features/chat_lobby/application/chat_lobby_service.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicProfileButtons extends ConsumerWidget {
  const PublicProfileButtons({super.key, required this.otherProfileId});

  final String otherProfileId;

  void _joinChatRoom(BuildContext context, WidgetRef ref) async {
    final router = context.router;

    final room = await ref
        .read(chatLobbyServiceProvider)
        .findOrCreateRoom(otherProfileId);

    router.replaceAll([
      const ChatNavigation(),
      const ChatLobbyRoute(),
      ChatRoomRoute(roomId: room.id, otherProfileId: otherProfileId),
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final joinedValue =
        ref.watch(publicProfileButtonsControllerProvider(otherProfileId));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton.extended(
          key: K.publicProfileSendMsgButton,
          icon: const Icon(Icons.message),
          label: const Text('Send Message'),
          heroTag: null,
          onPressed: () => _joinChatRoom(context, ref),
        ),
        const SizedBox(width: 12),
        joinedValue.maybeWhen(
          data: (joined) => joined
              ? VideoCallButton(
                  buttonType: VideoCallButtonType.profile,
                  otherProfileId: otherProfileId,
                )
              : const SizedBox.shrink(),
          orElse: () => const SizedBox.shrink(),
        ),
        // TODO: Add Follow Button
        // FloatingActionButton.extended(
        //   icon: const Icon(Icons.follow),
        //   label: const Text('Follow'),
        //   heroTag: 'tag2',
        //   onPressed: () {},
        // )
      ],
    );
  }
}
