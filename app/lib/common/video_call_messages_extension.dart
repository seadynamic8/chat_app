import 'package:chat_app/common/alert_dialogs.dart';
import 'package:chat_app/common/error_snackbar.dart';
import 'package:chat_app/features/auth/domain/block_state.dart';
import 'package:chat_app/features/auth/domain/user_access.dart';
import 'package:chat_app/features/home/domain/online_state.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/cupertino.dart';

extension VideoCallMessagesExtension on BuildContext {
  Future<bool> showRechargeMessage(AccessLevel accessLevel) async {
    if (accessLevel == AccessLevel.standard) {
      final isRecharge = await showAlertDialog(
          context: this,
          title: 'No more coins left',
          content: 'Would you like to get more coins?',
          cancelActionText: 'No',
          defaultActionText: 'Yes');
      return isRecharge ?? false;
    }
    return false;
  }

  void showStatusMessage(OnlineStatus userStatus) {
    showSnackBar(userStatus == OnlineStatus.busy
        ? 'User is busy right now.'.i18n
        : 'User is offline right now.'.i18n);
  }

  void showBlockMessage(BlockState blockState) {
    showErrorSnackBar('${blockState.message}, cannot video call');
  }

  void logAndShowError(String className, error, StackTrace st) {
    logger.e('$className Error: $error', error: error, stackTrace: st);

    showSnackBar(
        'Unable to create video call right now, please try again later.'.i18n);
  }
}
