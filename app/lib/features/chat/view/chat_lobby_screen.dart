import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class ChatLobbyScreen extends ConsumerWidget {
  const ChatLobbyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This beginning code here is because AutoRoute tabs keep state when
    // changing tabs, which causes Riverpod to not refresh the state.

    // Probably a better way to get the tabsRouter
    final tabsRouter =
        context.router.innerRouterOf<TabsRouter>(TabsNavigation.name);
    // Add a listener on the parent router
    // Once the tabs router comes back, it will invalidate the cached rooms
    // Thereby re-fetching new rooms.
    context.router.parent()!.addListener(() {
      // 1 = Chats Lobby Route
      if (tabsRouter!.activeIndex == 1) {
        ref.invalidate(getAllRoomsProvider);
      }
    });

    final roomsValue = ref.watch(getAllRoomsProvider);

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
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                      rooms[index].otherProfile!.avatarUrl ??
                          'assets/images/user_default_image.png'),
                  radius: 15,
                ),
                title: Text(rooms[index].otherProfile!.username!),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
