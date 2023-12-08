import 'package:chat_app/features/chat/view/chat_more_menu_controller.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class ChatMoreMenu extends ConsumerWidget {
  const ChatMoreMenu({
    super.key,
    required this.roomId,
    required this.otherProfileId,
  });

  final String roomId;
  final String otherProfileId;

  void _toggleBlockSelected(WidgetRef ref) {
    ref
        .read(chatMoreMenuControllerProvider(roomId, otherProfileId).notifier)
        .toggleBlock();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatBlockState =
        ref.watch(chatMoreMenuControllerProvider(roomId, otherProfileId));

    return chatBlockState.maybeWhen(
        data: (chatBlockState) => MenuAnchor(
              key: K.chatRoomMoreOptionsMenu,
              builder: (context, controller, child) {
                return IconButton(
                  key: K.chatRoomMoreOptionsButton,
                  onPressed: () {
                    controller.isOpen ? controller.close() : controller.open();
                  },
                  icon: const Icon(Icons.more_vert),
                  tooltip: 'Show menu'.i18n,
                );
              },
              menuChildren: [
                MenuItemButton(
                  key: K.chatRoomBlockToggleButton,
                  onPressed: () => _toggleBlockSelected(ref),
                  child: Text(toBeginningOfSentenceCase(chatBlockState.name) ??
                      chatBlockState.name),
                ),
              ],
            ),
        orElse: () => const SizedBox.shrink());
  }
}
