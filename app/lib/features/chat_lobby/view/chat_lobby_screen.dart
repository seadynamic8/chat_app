import 'package:chat_app/features/chat_lobby/domain/room.dart';
import 'package:chat_app/features/chat_lobby/view/chat_lobby_list.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class ChatLobbyScreen extends ConsumerWidget {
  const ChatLobbyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return I18n(
      child: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Chats'.i18n),
              bottom: const TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(text: 'All'),
                  Tab(text: 'Unread Only'),
                  Tab(text: 'Requests'),
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
