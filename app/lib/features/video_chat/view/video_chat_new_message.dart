import 'package:chat_app/common/error_snackbar.dart';
import 'package:chat_app/features/video_chat/data/video_chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoChatNewMessage extends ConsumerStatefulWidget {
  const VideoChatNewMessage({super.key});

  @override
  ConsumerState<VideoChatNewMessage> createState() =>
      _VideoChatNewMessageState();
}

class _VideoChatNewMessageState extends ConsumerState<VideoChatNewMessage> {
  final _messageController = TextEditingController();

  void _submitMessage() async {
    final messageText = _messageController.text.trim();

    if (messageText.isEmpty) {
      context.showSnackBar('Please enter a message');
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();

    _sendVideoChatMessage(messageText);
  }

  void _sendVideoChatMessage(String message) async {
    await ref.watch(videoChatRepositoryProvider).send(message: message);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                boxShadow: [
                  BoxShadow(color: Colors.black45),
                ],
              ),
              child: TextFormField(
                controller: _messageController,
                textCapitalization: TextCapitalization.sentences,
                enableSuggestions: true,
                autocorrect: true,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white.withAlpha(200),
                decoration: InputDecoration(
                  hintText: 'Send a message...',
                  hintStyle: theme.textTheme.bodyMedium!.copyWith(
                    color: Colors.white.withAlpha(230),
                  ),
                  border: InputBorder.none,
                ),
                onFieldSubmitted: (value) => _submitMessage(),
              ),
            ),
          ),
          // Send Button
          IconButton(
            color: theme.colorScheme.onBackground.withAlpha(230),
            onPressed: _submitMessage,
            icon: const Icon(
              Icons.send,
              shadows: [
                Shadow(
                  color: Colors.black87,
                  blurRadius: 1,
                  offset: Offset(0.3, 0.3),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
