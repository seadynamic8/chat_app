import 'package:chat_app/common/paginated_list_view.dart';
import 'package:chat_app/features/chat_lobby/domain/room.dart';
import 'package:chat_app/features/chat_lobby/view/chat_lobby_controller.dart';
import 'package:chat_app/features/chat_lobby/view/chat_lobby_item.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatLobbyList extends ConsumerWidget {
  const ChatLobbyList({super.key, required this.roomType});

  final RoomType roomType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ScrollController();
    final stateValue = ref.watch(chatLobbyControllerProvider(roomType));

    final getNextPage = ref
        .read(chatLobbyControllerProvider(roomType).notifier)
        .getNextPageOfRooms;

    return PaginatedListView<Room>(
      scrollController: scrollController,
      getNextPage: getNextPage,
      itemsLabel: 'chats'.i18n,
      value: stateValue,
      data: (state) {
        final rooms = state.items;

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: rooms.length,
            (context, index) {
              final room = rooms[index];

              return ChatLobbyItem(key: ValueKey(room.id), roomId: room.id);
            },
          ),
        );
      },
    );
  }
}
