import 'package:chat_app/common/error_message_widget.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
  });

  final AsyncValue<T> value;
  final Widget Function(T) data;
  final Widget? loading;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (e, st) {
        logger.e('Error', error: e, stackTrace: st);
        return const Center(
          child: ErrorMessageWidget('Error: Something went wrong'),
        );
      },
      loading: () => loading == null
          ? const Center(child: CircularProgressIndicator())
          : loading!,
    );
  }
}
