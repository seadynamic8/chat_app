import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsernameWidget extends ConsumerWidget {
  const UsernameWidget({
    super.key,
    required this.profileId,
    this.textStyle,
  });

  final String profileId;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final usernameValue = ref.watch(
      profileStreamProvider(profileId).select(
        (value) => value.whenData((profile) => profile?.username),
      ),
    );

    return usernameValue.maybeWhen(
      data: (otherUsername) => Text(
        otherUsername!,
        style: textStyle ??
            theme.textTheme.labelLarge!.copyWith(
              fontSize: 15,
            ),
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
      orElse: SizedBox.shrink,
    );
  }
}
