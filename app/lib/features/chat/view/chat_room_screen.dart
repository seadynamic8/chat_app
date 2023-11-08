import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/view/chat_messages.dart';
import 'package:chat_app/features/chat/view/chat_room_top_bar.dart';
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
            appBar: ChatRoomTopBar(otherProfile: profiles[otherProfileId]!),
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
