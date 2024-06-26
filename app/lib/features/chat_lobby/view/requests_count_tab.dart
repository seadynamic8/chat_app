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
    final requestsCountValue = ref.watch(
        chatLobbyControllerProvider(RoomType.requests).select(
            (value) => value.whenData((pageState) => pageState.items.length)));

    return Tab(
      child: AsyncValueWidget(
        value: requestsCountValue,
        data: (requestsCount) => requestsCount > 0
            ? Badge(
                alignment: const Alignment(2, 2),
                backgroundColor: Colors.grey[700],
                label: Text(
                  requestsCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: requestsText,
              )
            : requestsText,
      ),
    );
  }
}
