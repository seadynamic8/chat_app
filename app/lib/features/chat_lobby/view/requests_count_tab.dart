import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/chat_lobby/domain/room.dart';
import 'package:chat_app/features/chat_lobby/view/chat_lobby_controller.dart';
import 'package:flutter/material.dart';

class RequestsCountTab extends ConsumerWidget {
  const RequestsCountTab({super.key});

  final requestsText = const Text('Requests');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final requestsCountValue = ref.watch(
        chatLobbyControllerProvider(RoomType.requests).select(
            (value) => value.whenData((pageState) => pageState.items.length)));

    return Tab(
      child: AsyncValueWidget(
        value: requestsCountValue,
        data: (requestsCount) => requestsCount > 0
            ? Badge(
                alignment: const Alignment(2, 2),
                backgroundColor: theme.colorScheme.secondaryContainer,
                label: Text(requestsCount.toString()),
                child: requestsText,
              )
            : requestsText,
      ),
    );
  }
}
