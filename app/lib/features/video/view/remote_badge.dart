import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:country_flags/country_flags.dart';
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
        padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
        child: Row(
          children: [
            // AVATAR
            CircleAvatar(
              backgroundImage: const AssetImage(defaultAvatarImage),
              foregroundImage: otherProfile.avatarUrl == null
                  ? null
                  : NetworkImage(otherProfile.avatarUrl!),
              radius: 13,
            ),
            const SizedBox(width: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // USERNAME
                Text(otherProfile.username!),
                const SizedBox(height: 4),

                // COUNTRY
                CountryFlag.fromCountryCode(
                  otherProfile.country!,
                  height: 9,
                  width: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
