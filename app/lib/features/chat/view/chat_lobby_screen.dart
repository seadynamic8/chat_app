import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/chat/view/chat_lobby_controller.dart';
import 'package:chat_app/features/chat/view/chat_lobby_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class ChatLobbyScreen extends ConsumerWidget {
  const ChatLobbyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsValue = ref.watch(chatLobbyControllerProvider);

    return I18n(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Chats'),
          ),
          body: AsyncValueWidget(
            value: roomsValue,
            data: (rooms) => ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final room = rooms[index];

                return ChatLobbyItem(key: ValueKey(room.id), roomId: room.id);
              },
            ),
          ),
        ),
      ),
    );
  }
}
