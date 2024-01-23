import 'package:chat_app/common/scroll_to_end_button.dart';
import 'package:chat_app/features/chat/data/swiped_message_provider.dart';
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
class ChatRoomScreen extends ConsumerStatefulWidget {
  const ChatRoomScreen({
    super.key,
    required this.roomId,
    required this.otherProfileId,
  });

  final String roomId;
  final String otherProfileId;

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    ref.watch(swipedMessageProvider);

    return I18n(
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: SafeArea(
          child: KeyboardDismissOnTap(
            child: Scaffold(
              key: K.chatRoom,
              appBar: ChatRoomTopBar(
                roomId: widget.roomId,
                otherProfileId: widget.otherProfileId,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ChatMessages(
                      key: K.chatRoomMessages,
                      roomId: widget.roomId,
                      otherProfileId: widget.otherProfileId,
                      scrollController: scrollController,
                      msgFieldFocusNode: _focusNode,
                    ),
                  ),
                  NewMessage(
                    roomId: widget.roomId,
                    otherProfileId: widget.otherProfileId,
                    focusNode: _focusNode,
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
