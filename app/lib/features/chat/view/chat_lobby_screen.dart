import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat/view/chat_lobby_controller.dart';
import 'package:chat_app/features/chat/view/chat_online_status_icon.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

@RoutePage()
class ChatLobbyScreen extends ConsumerWidget {
  const ChatLobbyScreen({super.key});

  String _filterNewestMessage(WidgetRef ref, Message? newestMessage) {
    if (newestMessage == null) return '';

    final isCurrentUser = _messageIsCurrentUser(ref, newestMessage);

    if (newestMessage.type == 'video') {
      return '[ ${newestMessage.videoLabel(isCurrentUser)} ]';
    }
    if (newestMessage.translation != null && !isCurrentUser) {
      return newestMessage.translation!;
    }
    return newestMessage.content;
  }

  bool _messageIsCurrentUser(WidgetRef ref, Message message) {
    final currentUserId = ref.watch(authRepositoryProvider).currentUserId!;
    return message.profileId == currentUserId;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsValue = ref.watch(chatLobbyControllerProvider);

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
                        backgroundImage: const AssetImage(defaultAvatarImage),
                        foregroundImage: otherProfile.avatarUrl == null
                            ? null
                            : NetworkImage(otherProfile.avatarUrl!),
                        radius: 15,
                      ),
                      ChatOnlineStatusIcon(userId: otherProfile.id!)
                    ],
                  ),
                  title: Text(
                    otherProfile.username!,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  subtitle: Text(
                    _filterNewestMessage(ref, room.newestMessage),
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: Theme.of(context).hintColor),
                    overflow: TextOverflow.fade,
                  ),
                  trailing: Text(room.newestMessage != null
                      ? timeago.format(room.newestMessage!.createdAt!)
                      : ''),
                  onTap: () {
                    context.router.push(ChatRoomRoute(
                        roomId: room.id, otherProfileId: otherProfile.id!));
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
