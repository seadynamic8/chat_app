import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:flutter/material.dart';

class RemoteBadge extends StatelessWidget {
  const RemoteBadge({super.key, required this.otherProfile});

  final Profile otherProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: const AssetImage(defaultAvatarImage),
              foregroundImage: otherProfile.avatarUrl == null
                  ? null
                  : NetworkImage(otherProfile.avatarUrl!),
              radius: 13,
            ),
            const SizedBox(width: 8),
            Text(otherProfile.username!),
          ],
        ),
      ),
    );
  }
}
