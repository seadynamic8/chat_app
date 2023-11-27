import 'package:chat_app/utils/keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import '../../app_initializer.dart';
import '../../robot.dart';
import 'data/auth_admin_repository.dart';

void main() {
  const email = 'fake@test.com';
  const username = 'fake1234';
  const password = 'test1234';
  late final AuthAdminRepository authAdminRepository;

  setUp(() async {
    await AppInitializer().setup();
    authAdminRepository = AuthAdminRepository();
    authAdminRepository.deleteUserByEmail(email);
  });

  tearDown(() async {
    authAdminRepository.deleteUserByEmail(email);
  });

  patrolTest(
    'login and logout flow',
    ($) async {
      final r = Robot($: $);
      await r.pumpAndSettleMyApp(preSetup: false);

      expect($('Log In').exists, equals(true));

      // Switch to Sign Up form
      await $(K.authFormTypeToggle).tap();
      expect($('Sign Up'), findsWidgets);

      // Sign up
      await $(K.authFormEmailField).enterText(email);
      await $(K.authFormPasswordField).enterText(password);
      await $(K.authFormSubmitButton).tap();

      await r.verifyPIN(email);

      // Signup Screen One
      expect($('Welcome!'), findsOneWidget);

      final dropdown = $(K.signUpBirthdateDropdown);
      await dropdown.$('January').tap();
      await $('June').scrollTo().tap();
      await dropdown.$('1').tap();
      await $('3').scrollTo().tap();
      await dropdown.$('2008').tap();
      await $('1984').scrollTo().tap();
      await $(K.signUpGenderMaleButton).tap();
      await $(K.signUpScreenOneNextButton).tap();

      // Signup Screen Two
      expect($('Please choose an image:'), findsOneWidget);

      // Test Back Button
      await $(K.signUpScreenTwoBackButton).tap();
      expect($('Welcome!'), findsOneWidget);
      await $(K.signUpScreenOneNextButton).tap();
      expect($('Please choose an image:'), findsOneWidget);

      // No way to test imagePicker, or rather, can't really select pics for now
      // await $(K.signUpImagePicker).tap();
      await $(K.signUpUsernameField).enterText(username);
      await $(K.signUpScreenTwoFinishButton).tap();

      // Finished Signing up
      expect($('Explore'), findsWidgets);

      await $(K.profileTab).tap();

      // Profile Page
      expect($('Profile'), findsWidgets);

      expect($(username), findsOneWidget);
      expect($('39'), findsOneWidget); // Birthdate => Age

      // Logout
      await $(K.privateProfileSettingsBtn).tap();
      await $(K.settingsLogoutTile).tap();

      expect($('Log In').exists, equals(true));

      // Login
      await $(K.authFormEmailField).enterText(email);
      await $(K.authFormPasswordField).enterText(password);
      await $(K.authFormSubmitButton).tap();

      expect($('Explore'), findsWidgets);
    },
  );
}
