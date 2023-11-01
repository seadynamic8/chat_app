import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/view/chat_messages.dart';
import 'package:chat_app/features/chat/view/new_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class ChatRoomScreen extends ConsumerWidget {
  const ChatRoomScreen({
    super.key,
    @PathParam('id') required this.roomId,
    required this.otherProfileId,
  });

  final String roomId;
  final String otherProfileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesValue = ref.watch(getProfilesForRoomProvider(roomId));

    return I18n(
      child: SafeArea(
        child: AsyncValueWidget(
          value: profilesValue,
          data: (profiles) => Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(
                        profiles[otherProfileId]?.avatarUrl ??
                            'assets/images/user_default_image.png'),
                    radius: 15,
                  ),
                  const SizedBox(width: 15),
                  Text(profiles[otherProfileId]?.username ?? 'Chat Room'),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ChatMessages(roomId: roomId, profiles: profiles),
                ),
                NewMessage(roomId: roomId),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
