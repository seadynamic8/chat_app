import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/avatar_online_status.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter/material.dart';

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: K.searchScreenResultTile,
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      leading: AvatarOnlineStatus(
        key: K.chatLobbyItemAvatar,
        profileId: profile.id!,
        radiusSize: 20,
      ),
      title: Text(
        profile.username ?? '',
        overflow: TextOverflow.fade,
        softWrap: false,
        maxLines: 1,
      ),
      onTap: () => context.router.push(
        PublicProfileRoute(profileId: profile.id!),
      ),
    );
  }
}
