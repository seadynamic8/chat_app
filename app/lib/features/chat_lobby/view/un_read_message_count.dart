import 'package:chat_app/features/chat_lobby/data/chat_lobby_repository.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnReadMessageCount extends ConsumerWidget {
  const UnReadMessageCount({super.key, required this.roomId});

  final String roomId;

  String unReadMessagesCountString(int unReadCount) {
    if (unReadCount > 99) {
      return '99+';
    }
    return unReadCount.toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unReadMessageCountStream =
        ref.watch(unReadMessageCountStreamProvider(roomId));

    const emptyWidget = Text('');

    return unReadMessageCountStream.maybeWhen(
      data: (unReadMessageCount) => (unReadMessageCount > 0)
          ? Container(
              key: K.chatLobbyItemUnReadMsgCount,
              constraints: const BoxConstraints(
                minWidth: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(200),
                // shape: BoxShape.circle,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                child: Text(
                  unReadMessagesCountString(unReadMessageCount),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontSize: 10,
                      ),
                ),
              ),
            )
          : emptyWidget,
      orElse: () => emptyWidget,
    );
  }
}
