import 'package:chat_app/utils/keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import '../../app_initializer.dart';
import '../../robot.dart';
import '../../common/auth_admin_repository.dart';

void main() {
  const email = 'fake@test.com';
  const oldPassword = 'oldFakePassword1234';
  const newPassword = 'newFakePassword1234';
  late final AuthAdminRepository authAdminRepository;

  setUp(() async {
    await AppInitializer().setup();
    authAdminRepository = AuthAdminRepository();
    await authAdminRepository.deleteUserByEmail(email);
    await authAdminRepository.createUser(
        email: email, password: oldPassword, emailConfirm: false);
  });

  tearDown(() async {
    await authAdminRepository.deleteUserByEmail(email);
  });

  patrolTest('forgot password', ($) async {
    final r = Robot($: $);
    await r.pumpAndSettleMyApp(preSetup: false);

    expect($('Sign Up').exists, equals(true));

    // Toggle to Login Form
    await $(K.authFormTypeToggle).tap();
    expect($('Log In').exists, equals(true));

    // Tap Forgot Password Button
    await $(K.authFormForgotPasswordBtn).tap();

    // Forgot Password Back Button
    expect($(K.forgotPasswordPrompt), findsOneWidget);
    await $(K.forgotPasswordBackButton).tap();
    expect($('Log In').exists, equals(true));
    await $(K.authFormForgotPasswordBtn).tap();

    expect($(K.forgotPasswordPrompt), findsOneWidget);

    await $(K.forgotPasswordEmailField).enterText(email);
    await $(K.forgotPasswordSubmitButton).tap();

    await r.verifyPIN(email);

    expect($(K.resetPasswordPrompt), findsOneWidget);

    await $(K.resetPasswordField).enterText(newPassword);
    await $(K.resetPasswordSubmitButton).tap();

    // Reset finished, logged in.
    expect($('Explore'), findsWidgets);

    await $(K.profileTab).tap();

    // Profile Page
    expect($('Profile'), findsWidgets);

    // Logout
    await $(K.privateProfileSettingsBtn).tap();
    await $(K.settingsLogoutTile).tap();

    expect($('Sign Up').exists, equals(true));

    // Toggle to Login Form
    await $(K.authFormTypeToggle).tap();
    expect($('Log In').exists, equals(true));

    // Login
    await $(K.authFormEmailField).enterText(email);
    await $(K.authFormPasswordField).enterText(newPassword);
    await $(K.authFormSubmitButton).tap();

    // Login successful with new password
    expect($('Explore'), findsWidgets);
  });
}
