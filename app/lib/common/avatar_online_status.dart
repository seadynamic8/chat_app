import 'package:chat_app/common/avatar_image.dart';
import 'package:chat_app/common/chat_online_status_icon.dart';
import 'package:flutter/material.dart';

class AvatarOnlineStatus extends StatelessWidget {
  const AvatarOnlineStatus({
    super.key,
    required this.profileId,
    required this.radiusSize,
    this.showLoading = false,
  });

  final String profileId;
  final double radiusSize;
  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AvatarImage(
          profileId: profileId,
          radiusSize: radiusSize,
          showLoading: showLoading,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ChatOnlineStatusIcon(userId: profileId),
        )
      ],
    );
  }
}
