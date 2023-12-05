import 'package:chat_app/common/paginated_list_view.dart';
import 'package:chat_app/features/chat_lobby/domain/room.dart';
import 'package:chat_app/features/chat_lobby/view/chat_lobby_controller.dart';
import 'package:chat_app/features/chat_lobby/view/chat_lobby_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class ChatLobbyScreen extends ConsumerWidget {
  const ChatLobbyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ScrollController();
    final stateValue = ref.watch(chatLobbyControllerProvider);

    final getNextPage =
        ref.read(chatLobbyControllerProvider.notifier).getNextPageOfRooms;

    return I18n(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Chats'),
          ),
          body: PaginatedListView<Room>(
            scrollController: scrollController,
            getNextPage: getNextPage,
            value: stateValue,
            data: (state) {
              final rooms = state.items;

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: rooms.length,
                  (context, index) {
                    final room = rooms[index];

                    return ChatLobbyItem(
                        key: ValueKey(room.id), roomId: room.id);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
