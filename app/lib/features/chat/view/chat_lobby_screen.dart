import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/home/application/online_presences.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

@RoutePage()
class ChatLobbyScreen extends ConsumerWidget {
  const ChatLobbyScreen({super.key});

  String newestMessage(WidgetRef ref, Message? newestMessage) {
    if (newestMessage == null) return '';

    if (newestMessage.translation != null) {
      // For now, we use username for tracking presence since it's easier to debug
      final currentUserName =
          ref.watch(authRepositoryProvider).currentUserName!;
      if (newestMessage.profileId != currentUserName) {
        return newestMessage.translation!;
      }
    }
    return newestMessage.content;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsValue = ref.watch(getAllRoomsProvider);
    final onlineStates = ref.watch(onlinePresencesProvider);

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
                final otherProfile = room.otherProfile!;

                return ListTile(
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(otherProfile.avatarUrl ??
                            'assets/images/user_default_image.png'),
                        radius: 15,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Icon(
                          Icons.circle,
                          size: 10,
                          color: onlineStates[otherProfile.username] == null
                              ? Colors.grey
                              : onlineStates[otherProfile.username]!.status ==
                                      OnlineStatus.online
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    otherProfile.username!,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  subtitle: Text(
                    newestMessage(ref, room.newestMessage),
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: Theme.of(context).hintColor),
                  ),
                  trailing: Text(room.newestMessage != null
                      ? timeago.format(room.newestMessage!.createdAt!)
                      : ''),
                  onTap: () {
                    context.router.push(ChatRoomRoute(
                        roomId: room.id, otherProfileId: otherProfile.id));
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
