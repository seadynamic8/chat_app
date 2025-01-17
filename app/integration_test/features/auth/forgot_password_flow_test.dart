import 'package:chat_app/utils/keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import '../../app_initializer.dart';
import '../../robot.dart';
import '../../test_helper.dart';

void main() {
  const email = 'fake@test.com';
  const oldPassword = 'oldFakePassword1234';
  const newPassword = 'newFakePassword1234';
  late final TestHelper t;

  setUp(() async {
    await AppInitializer().setup();
    t = TestHelper();
    await t.signOut();
    await t.createUser(
        email: email, password: oldPassword, autoConfirmEmail: false);
  });

  tearDown(() async {
    await t.clearUser(email: email);
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

    // FORGOT PASSWORD SCREEN
    expect($(K.forgotPasswordPrompt), findsOneWidget);

    await $(K.forgotPasswordEmailField).enterText(email);
    await $(K.forgotPasswordSubmitButton).tap();

    // VERIFY PIN SCREEN
    expect($('Verify PIN'), findsWidgets);

    // * Comment out for now because it slows down test considerbly,
    // * need to wait (delay) 60s for resend email
    // await $.tester.pump(const Duration(seconds: 60));
    // await $(K.authVerifyFormResendButton).tap();

    await r.verifyPIN(email);

    // RESET PASSWORD SCREEN
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
