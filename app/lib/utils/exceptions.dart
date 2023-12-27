import 'package:chat_app/i18n/localizations.dart';

class DuplicateEmailException implements Exception {
  String get message => 'This email has already registered.'.i18n;
}

class DuplicateUsernameException implements Exception {
  String get message =>
      'Username is already taken, please try another one.'.i18n;
}
