import 'package:chat_app/features/auth/view/auth/auth_form_state.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/utils/string_validators.dart';

enum PasswordChangeType { oldPassword, newPassword }

mixin UserInputValidation {
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordSignupSubmitValidator =
      MinLengthStringValidator(8);
  final StringValidator passwordLogInSubmitValidator =
      NonEmptyStringValidator();
  // final StringValidator oldPasswordValidator = NonEmptyStringValidator();
  final StringValidator newPasswordValidaotr = MinLengthStringValidator(8);

  bool canSubmitEmail(String email) {
    return emailSubmitValidator.isValid(email);
  }

  bool canSubmitPassword(AuthFormType formType, String password) {
    if (formType == AuthFormType.signup) {
      return passwordSignupSubmitValidator.isValid(password);
    }
    return passwordLogInSubmitValidator.isValid(password);
  }

  bool canChangePassword(PasswordChangeType passChangeType, String password) {
    // if (passChangeType == PasswordChangeType.oldPassword) {
    //   return oldPasswordValidator.isValid(password);
    // }
    return newPasswordValidaotr.isValid(password);
  }

  String? emailErrorText(String email) {
    final bool showErrorText = !canSubmitEmail(email);
    final String errorText =
        email.isEmpty ? 'Email can\'t be empty'.i18n : 'Invalid email'.i18n;
    return showErrorText ? errorText : null;
  }

  String? passwordErrorText(bool showErrorText, String password) {
    final String errorText = password.isEmpty
        ? 'Password can\'t be empty'.i18n
        : 'Password is too short'.i18n;
    return showErrorText ? errorText : null;
  }
}
