import 'package:chat_app/features/auth/presentation/string_validators.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

enum AuthFormType { login, signup }

mixin EmailAndPasswordValidators {
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator usernameSubmitValidator =
      UsernameSubmitRegexValidator();
  final StringValidator passwordSignupSubmitValidator =
      MinLengthStringValidator(8);
  final StringValidator passwordLogInSubmitValidator =
      NonEmptyStringValidator();
}

class AuthFormState with EmailAndPasswordValidators {
  AuthFormState({
    this.formType = AuthFormType.login,
    this.value = const AsyncData(null),
  });

  final AuthFormType formType;
  final AsyncValue<void> value;

  AuthFormState copyWith({
    AuthFormType? formType,
    AsyncValue<void>? value,
  }) {
    return AuthFormState(
      formType: formType ?? this.formType,
      value: value ?? this.value,
    );
  }

  @override
  String toString() => 'AuthFormState(formType: $formType, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthFormState &&
        other.formType == formType &&
        other.value == value;
  }

  @override
  int get hashCode => formType.hashCode ^ value.hashCode;
}

extension AuthFormStateX on AuthFormState {
  String get passwordLabelText {
    if (formType == AuthFormType.signup) {
      return 'Password (8+ characters)'.i18n;
    } else {
      return 'Password'.i18n;
    }
  }

  // Getters
  String get primaryButtonText {
    if (formType == AuthFormType.signup) {
      return 'Create an account'.i18n;
    } else {
      return 'Log In'.i18n;
    }
  }

  String get secondaryButtonText {
    if (formType == AuthFormType.signup) {
      return 'Have an account? Log in'.i18n;
    } else {
      return 'Need an account? Sign up'.i18n;
    }
  }

  AuthFormType get secondaryActionFormType {
    if (formType == AuthFormType.signup) {
      return AuthFormType.login;
    } else {
      return AuthFormType.signup;
    }
  }

  String get errorAlertTitle {
    if (formType == AuthFormType.signup) {
      return 'Sign Up failed'.i18n;
    } else {
      return 'Log in failed'.i18n;
    }
  }

  String get title {
    if (formType == AuthFormType.signup) {
      return 'Sign Up'.i18n;
    } else {
      return 'Log In'.i18n;
    }
  }

  bool canSubmitEmail(String email) {
    return emailSubmitValidator.isValid(email);
  }

  bool canSubmitUsername(String username) {
    return usernameSubmitValidator.isValid(username);
  }

  bool canSubmitPassword(String password) {
    if (formType == AuthFormType.signup) {
      return passwordSignupSubmitValidator.isValid(password);
    }
    return passwordLogInSubmitValidator.isValid(password);
  }

  String? emailErrorText(String email) {
    final bool showErrorText = !canSubmitEmail(email);
    final String errorText =
        email.isEmpty ? 'Email can\'t be empty'.i18n : 'Invalid email'.i18n;
    return showErrorText ? errorText : null;
  }

  String? usernameErrorText(String username) {
    final bool showErrorText = !canSubmitUsername(username);
    final String errorText =
        'Username needs 3-24 characters with alphanumeric or underscore'.i18n;
    return showErrorText ? errorText : null;
  }

  String? passwordErrorText(String password) {
    final bool showErrorText = !canSubmitPassword(password);
    final String errorText = password.isEmpty
        ? 'Password can\'t be empty'.i18n
        : 'Password is too short'.i18n;
    return showErrorText ? errorText : null;
  }
}
