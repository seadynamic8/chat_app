import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

class RemoteBadge extends ConsumerWidget {
  const RemoteBadge({super.key, required this.otherProfileId});

  final String otherProfileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherProfileValue = ref.watch(profileStreamProvider(otherProfileId));

    return otherProfileValue.maybeWhen(
      data: (otherProfile) => Container(
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
      ),
      orElse: SizedBox.shrink,
    );
  }
}
