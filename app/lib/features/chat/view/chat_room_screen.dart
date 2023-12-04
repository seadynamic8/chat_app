import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/chat/view/chat_messages.dart';
import 'package:chat_app/features/chat/view/chat_room_screen_controller.dart';
import 'package:chat_app/features/chat/view/chat_room_top_bar.dart';
import 'package:chat_app/features/chat/view/new_message.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class ChatRoomScreen extends ConsumerWidget {
  const ChatRoomScreen({
    super.key,
    required this.roomId,
    required this.otherProfileId,
  });

  final String roomId;
  final String otherProfileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesValue =
        ref.watch(chatRoomScreenControllerProvider(otherProfileId));

    return I18n(
      child: SafeArea(
        child: KeyboardDismissOnTap(
          child: AsyncValueWidget(
            value: profilesValue,
            data: (profiles) => Scaffold(
              key: K.chatRoom,
              appBar: ChatRoomTopBar(otherProfile: profiles[otherProfileId]!),
              body: Column(
                children: [
                  Expanded(
                    child: ChatMessages(
                      key: K.chatRoomMessages,
                      roomId: roomId,
                      profiles: profiles,
                    ),
                  ),
                  NewMessage(
                    roomId: roomId,
                    otherProfileId: otherProfileId,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
