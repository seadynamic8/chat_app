import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/user_access.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallPrice extends ConsumerWidget {
  const CallPrice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessLevelValue = ref.read(userAccessStreamProvider
        .select((value) => value.whenData((userAccess) => userAccess.level)));

    return accessLevelValue.maybeWhen(
      data: (accessLevel) => accessLevel == AccessLevel.premium
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Calling for: 10',
                  style: Theme.of(context).textTheme.titleSmall!,
                ),
                const SizedBox(width: 5),
                const Icon(Icons.stars_rounded),
                const SizedBox(width: 5),
                Text(
                  '/min',
                  style: Theme.of(context).textTheme.titleSmall!,
                ),
              ],
            )
          : Center(
              child: Text('Calling for Free'.i18n),
            ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}
