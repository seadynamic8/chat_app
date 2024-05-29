import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/home/application/current_user_id_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:flutter/material.dart';

class AvatarImage extends ConsumerWidget {
  const AvatarImage({
    super.key,
    required this.profileId,
    required this.radiusSize,
    this.showLoading = false,
  });

  final String profileId;
  final double radiusSize;
  final bool showLoading;

  bool isCurrentUser(WidgetRef ref, String profileId) {
    final currentUserId = ref.watch(currentUserIdProvider)!;
    return currentUserId == profileId;
  }

  AsyncValue<String?> getAvatarUrlValue(WidgetRef ref, String profileId) {
    if (isCurrentUser(ref, profileId)) {
      return ref.watch(currentProfileStreamProvider
          .select((value) => value.whenData((profile) => profile!.avatarUrl)));
    }
    return ref.watch(profileStreamProvider(profileId)
        .select((value) => value.whenData((profile) => profile.avatarUrl)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarUrlValue = getAvatarUrlValue(ref, profileId);

    return AsyncValueWidget(
      value: avatarUrlValue,
      data: (avatarUrl) => CircleAvatar(
        backgroundImage: const AssetImage(defaultAvatarImage),
        foregroundImage: avatarUrl == null ? null : NetworkImage(avatarUrl),
        radius: radiusSize,
      ),
      showLoading: showLoading,
      showError: false,
    );
  }
}
