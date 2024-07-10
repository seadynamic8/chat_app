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
        .select((value) => value.whenData((userAccess) => userAccess?.level)));

    return accessLevelValue.maybeWhen(
      data: (accessLevel) => switch (accessLevel) {
        AccessLevel.trial => Center(
            child: Text('Calling for Free (Trial)'.i18n),
          ),
        AccessLevel.free => Center(
            child: Text('Calling for Free'.i18n),
          ),
        _ => const SizedBox.shrink(),
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
