import 'package:chat_app/common/error_snackbar.dart';
import 'package:chat_app/features/auth/domain/block_state.dart';
import 'package:chat_app/features/chat/application/chat_service.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewMessage extends ConsumerStatefulWidget {
  const NewMessage({
    super.key,
    required this.roomId,
    required this.otherProfileId,
    required this.joined,
  });

  final String roomId;
  final String otherProfileId;
  final bool joined;

  @override
  ConsumerState<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends ConsumerState<NewMessage> {
  final _messageController = TextEditingController();

  void _submitMessage() async {
    final messageText = _messageController.text.trim();

    if (messageText.isEmpty) {
      context.showSnackBar('Please enter a message');
      return;
    }
    _messageController.clear();

    final blockState = await ref.read(chatServiceProvider).sendMessage(
          roomId: widget.roomId,
          otherProfileId: widget.otherProfileId,
          messageText: messageText,
          joined: widget.joined,
        );

    _showBlockMessage(blockState);
  }

  void _showBlockMessage(BlockState blockState) {
    if (blockState.status == BlockStatus.no) return;
    context.showErrorSnackBar('${blockState.message}, cannot send message');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 1,
        bottom: 14,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              key: K.chatRoomNewMessageField,
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              autocorrect: true,
              decoration: const InputDecoration(hintText: 'Send a message...'),
              onEditingComplete: () {}, // Keep keyboard open after a message
              onFieldSubmitted: (value) => _submitMessage(),
            ),
          ),
          IconButton(
            key: K.chatRoomSendNewMessageBtn,
            color: Theme.of(context).colorScheme.primary,
            onPressed: _submitMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
