import 'package:chat_app/common/scroll_to_end_button.dart';
import 'package:chat_app/features/chat/view/chat_messages.dart';
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
    final scrollController = ScrollController();

    return I18n(
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: SafeArea(
          child: KeyboardDismissOnTap(
            child: Scaffold(
              key: K.chatRoom,
              appBar: ChatRoomTopBar(
                roomId: roomId,
                otherProfileId: otherProfileId,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ChatMessages(
                      key: K.chatRoomMessages,
                      roomId: roomId,
                      otherProfileId: otherProfileId,
                      scrollController: scrollController,
                    ),
                  ),
                  NewMessage(
                    roomId: roomId,
                    otherProfileId: otherProfileId,
                  ),
                ],
              ),
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(top: 90.0, left: 10),
                child: ScrollToEndButton(
                  scrollController: scrollController,
                  direction: ScrollDirection.bottom,
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.startTop,
            ),
          ),
        ),
      ),
    );
  }
}
