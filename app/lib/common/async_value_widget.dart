import 'package:chat_app/common/error_message_widget.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.showLoading = true,
    this.showError = true,
  });

  final AsyncValue<T> value;
  final Widget Function(T) data;
  final Widget? loading;
  final bool showLoading;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (error, st) {
        logError('AsyncValueWidget', error, st);

        return showLoading
            ? Center(
                child: ErrorMessageWidget('Something went wrong'.i18n),
              )
            : const SizedBox.shrink();
      },
      loading: () => showLoading
          ? loading == null
              ? const Center(child: CircularProgressIndicator())
              : loading!
          : const SizedBox.shrink(),
    );
  }
}
