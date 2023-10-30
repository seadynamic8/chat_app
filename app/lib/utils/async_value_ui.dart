import 'package:chat_app/common/alert_dialogs.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueUI on AsyncValue {
  void showAlertDialogOnError(BuildContext context) {
    if (!isLoading && hasError) {
      showExceptionAlertDialog(
        context: context,
        title: 'Error'.i18n,
        exception: error,
      );
    }
  }
}
