import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/common/avatar_online_status.dart';
import 'package:chat_app/features/chat_lobby/view/chat_lobby_item_controller.dart';
import 'package:chat_app/features/chat_lobby/view/newest_message_content.dart';
import 'package:chat_app/features/chat_lobby/view/un_read_message_count.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatLobbyItem extends ConsumerWidget {
  const ChatLobbyItem({super.key, required this.roomId});

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatLobbyItemValue =
        ref.watch(chatLobbyItemControllerProvider(roomId));

    final removedUserTile = ListTile(
      leading: const CircleAvatar(
        key: K.chatLobbyItemAvatar,
        backgroundImage: AssetImage(defaultAvatarImage),
        radius: 15,
      ),
      title: Text('User has been removed'.i18n,
          style: Theme.of(context).textTheme.titleSmall,
          overflow: TextOverflow.fade,
          softWrap: false),
    );

    return AsyncValueWidget(
      value: chatLobbyItemValue,
      data: (chatLobbyItem) => chatLobbyItem == null
          ? const SizedBox.shrink()
          : chatLobbyItem.otherProfile == null
              ? removedUserTile
              : ListTile(
                  key: ValueKey('${K.chatLobbyItemTilePrefix}$roomId'),
                  leading: AvatarOnlineStatus(
                    key: K.chatLobbyItemAvatar,
                    profileId: chatLobbyItem.otherProfile!.id!,
                    radiusSize: 15,
                  ),
                  title: Text(
                    chatLobbyItem.otherProfile!.username!,
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                  ),
                  subtitle: chatLobbyItem.newestMessage != null
                      ? NewestMessageContent(
                          key: K.chatLobbyItemNewestMsg,
                          newestMessage: chatLobbyItem.newestMessage!,
                        )
                      : null,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      chatLobbyItem.newestMessage != null
                          ? Text(
                              key: K.chatLobbyItemNewestMsgTime,
                              timeago.format(
                                  chatLobbyItem.newestMessage!.createdAt!),
                            )
                          : const Text(''),
                      UnReadMessageCount(roomId: roomId),
                    ],
                  ),
                  onTap: () {
                    context.router.push(ChatRoomRoute(
                        roomId: roomId,
                        otherProfileId: chatLobbyItem.otherProfile!.id!));
                  },
                ),
      loading: Shimmer.fromColors(
        baseColor: Colors.black38,
        highlightColor: Colors.white54,
        child: ListTile(
          leading: const CircleAvatar(
            radius: 20,
          ),
          title: Container(
            margin: const EdgeInsets.all(3),
            color: Colors.grey,
            child: const Text(''),
          ),
          subtitle: Container(
            margin: const EdgeInsets.all(3),
            color: Colors.grey,
            child: const Text(''),
          ),
        ),
      ),
    );
  }
}
