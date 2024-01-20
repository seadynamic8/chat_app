import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserLastActive extends ConsumerWidget {
  const UserLastActive({super.key, required this.profileId});

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final offlineAtValue = ref.watch(offlineAtProvider(profileId));

    return AsyncValueWidget(
      value: offlineAtValue,
      data: (offlineAt) => offlineAt != null
          ? Text(
              '${'Active'.i18n} ${timeago.format(offlineAt)}',
              style: theme.textTheme.bodySmall!.copyWith(
                color: theme.hintColor,
                fontSize: 11,
              ),
              overflow: TextOverflow.fade,
              softWrap: false,
            )
          : const SizedBox.shrink(),
      showLoading: false,
      showError: false,
    );
  }
}
