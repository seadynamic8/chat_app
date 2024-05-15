import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/chat_lobby/domain/room.dart';
import 'package:chat_app/features/chat_lobby/view/chat_lobby_controller.dart';
import 'package:chat_app/features/chat_lobby/view/chat_lobby_list.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';

@RoutePage()
class ChatLobbyScreen extends ConsumerWidget {
  const ChatLobbyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final requestsCountValue = ref.watch(
        chatLobbyControllerProvider(RoomType.requests).select(
            (value) => value.whenData((pageState) => pageState.items.length)));

    const requestsText = Text('Requests');

    return I18n(
      child: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Chats'.i18n),
              bottom: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  const Tab(text: 'All'),
                  const Tab(text: 'Unread Only'),
                  Tab(
                    child: AsyncValueWidget(
                      value: requestsCountValue,
                      data: (requestsCount) => requestsCount > 0
                          ? Badge(
                              alignment: const Alignment(2, 2),
                              backgroundColor:
                                  theme.colorScheme.secondaryContainer,
                              label: Text(requestsCount.toString()),
                              child: requestsText,
                            )
                          : requestsText,
                    ),
                  ),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                ChatLobbyList(roomType: RoomType.all),
                ChatLobbyList(roomType: RoomType.unRead),
                ChatLobbyList(roomType: RoomType.requests),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
