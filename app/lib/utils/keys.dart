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

  static const authVerifyFormPinput = Key('authVerifyFormPinput');
  static const authVerifyFormClearButton = Key('authVerifyFormClearButton');

  static const signUpBirthdateDropdown = Key('signUpBirthdateDropdown');
  static const signUpGenderMaleButton = Key('signUpGenderMaleButton');
  static const signUpGenderFemaleButton = Key('signUpGenderFemaleButton');
  static const signUpScreenOneNextButton = Key('signUpScreenOneNextButton');

  static const signUpImagePicker = Key('signUpImagePicker');
  static const signUpUsernameField = Key('signUpUsernameField');
  static const signUpScreenTwoBackButton = Key('signUpScreenTwoBackButton');
  static const signUpScreenTwoFinishButton = Key('signUpScreenTwoFinishButton');

  static const privateProfileSettingsBtn = Key('privateProfileSettingsBtn');

  static const settingsLogoutTile = Key('settingsLogoutTile');
}
