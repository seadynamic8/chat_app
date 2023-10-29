import 'package:flutter/foundation.dart';

typedef K = Keys;

class Keys {
  // Main Bottom Navigation Tab Buttons
  static const contactsTab = Key('contactsTab');
  static const chatsTab = Key('chatsTab');
  static const profileTab = Key('profileTab');

  static const authFormEmailField = Key('authFormEmailField');
  static const authFormUsernameField = Key('authFormUsernameField');
  static const authFormPasswordField = Key('authFormPasswordField');
  static const authFormSubmitButton = Key('authFormSubmitButton');
  static const authFormTypeToggle = Key('authFormTypeToggle');
}
