import 'package:flutter/foundation.dart';

typedef K = Keys;

class Keys {
  // Main Bottom Navigation Tab Buttons
  static const exploreTab = Key('exploreTab');
  static const chatsTab = Key('chatsTab');
  static const chatsBadgeTab = Key('chatsBadgeTab');
  static const profileTab = Key('profileTab');

  static const authFormEmailField = Key('authFormEmailField');
  static const authFormUsernameField = Key('authFormUsernameField');
  static const authFormPasswordField = Key('authFormPasswordField');
  static const authFormForgotPasswordBtn = Key('authFormForgotPasswordBtn');
  static const authFormSubmitButton = Key('authFormSubmitButton');
  static const authFormTypeToggle = Key('authFormTypeToggle');

  static const authVerifyFormPinput = Key('authVerifyFormPinput');
  static const authVerifyFormClearButton = Key('authVerifyFormClearButton');
  static const authVerifyFormResendButton = Key('authVerifyFormResendButton');

  static const signUpBirthdateDropdown = Key('signUpBirthdateDropdown');
  static const signUpGenderMaleButton = Key('signUpGenderMaleButton');
  static const signUpGenderFemaleButton = Key('signUpGenderFemaleButton');
  static const signUpScreenOneNextButton = Key('signUpScreenOneNextButton');

  static const signUpImagePicker = Key('signUpImagePicker');
  static const signUpUsernameField = Key('signUpUsernameField');
  static const signUpScreenTwoBackButton = Key('signUpScreenTwoBackButton');
  static const signUpScreenTwoFinishButton = Key('signUpScreenTwoFinishButton');

  static const privateProfileEditBtn = Key('privateProfileEditBtn');
  static const privateProfileSettingsBtn = Key('privateProfileSettingsBtn');
  static const privateProfileInkWellToPublicProfile =
      Key('privateProfileInkWellToPublicProfile');

  static const editProfileAvatarField = Key('editProfileAvatarField');
  static const editProfileUsernameField = Key('editProfileUsernameField');
  static const editProfileBirthdateField = Key('editProfileBirthdateField');
  static const editProfileBioField = Key('editProfileBioField');
  static const editProfileCountryField = Key('editProfileCountryField');
  static const editProfileCountryPicker = Key('editProfileCountryPicker');
  static const editProfileLanguageField = Key('editProfileLanguageField');
  static const editProfileSaveButton = Key('editProfileSaveButton');

  static const settingsLogoutTile = Key('settingsLogoutTile');

  static const forgotPasswordPrompt = Key('forgotPasswordPrompt');
  static const forgotPasswordEmailField = Key('forgotPasswordEmailField');
  static const forgotPasswordBackButton = Key('forgotPasswordBackButton');
  static const forgotPasswordSubmitButton = Key('forgotPasswordSubmitButton');

  static const resetPasswordPrompt = Key('resetPasswordPrompt');
  static const resetPasswordField = Key('resetPasswordField');
  static const resetPasswordSubmitButton = Key('resetPasswordSubmitButton');

  static const exploreScreenSearchButton = Key('exploreScreenSearchButton');

  static const searchScreen = Key('searchScreen');
  static const searchScreenSearchField = Key('searchScreenSearchField');
  static const searchScreenResultTile = Key('searchScreenResultTile');

  static const publicProfile = Key('publicProfile');
  static const publicProfileSendMsgButton = Key('publicProfileSendMsgButton');
  static const publicProfileAvatarCoverImg = Key('publicProfileAvatarCoverImg');
  static const publicProfileBackButton = Key('publicProfileBackButton');

  static const chatLobbyItemTilePrefix = 'chatLobbyItemTile-';
  static const chatLobbyItemAvatar = Key('chatLobbyItemAvatar');
  static const chatLobbyItemNewestMsg = Key('chatLobbyItemNewestMsg');
  static const chatLobbyItemNewestMsgTime = Key('chatLobbyItemNewestMsgTime');
  static const chatLobbyItemUnReadMsgCount = Key('chatLobbyItemUnReadMsgCount');

  static const chatRoom = Key('chatRoom');
  static const chatRoomNewMessageField = Key('chatRoomNewMessageField');
  static const chatRoomSendNewMessageBtn = Key('chatRoomSendNewMessageBtn');
  static const chatRoomMessages = Key('chatRoomMessages');
}
