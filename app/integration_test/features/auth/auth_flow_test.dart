import 'package:age_calculator/age_calculator.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import '../../app_initializer.dart';
import '../../robot.dart';
import '../../test_helper.dart';

void main() {
  const email = 'fake@test.com';
  const username = 'fake1234';
  const password = 'test1234';
  const birthMonth = 'June';
  const birthMonthNumber = 6;
  const birthDay = '3';
  const birthYear = '2000';

  late final TestHelper t;

  setUp(() async {
    await AppInitializer().setup();
    t = TestHelper();
    await t.signOut();
    await t.clearUser(email: email);
  });

  tearDown(() async {
    await t.clearUser(email: email);
  });

  patrolTest(
    'login and logout flow',
    ($) async {
      final r = Robot($: $);
      await r.pumpAndSettleMyApp(preSetup: false);

      expect($('Sign Up'), findsWidgets);

      // Sign up
      await $(K.authFormEmailField).enterText(email);
      await $(K.authFormPasswordField).enterText(password);
      await $(K.authFormSubmitButton).tap();

      // * Comment out for now because it slows down test considerbly,
      // * need to wait (delay) 60s for resend email
      // await $.tester.pump(const Duration(seconds: 60));
      // await $(K.authVerifyFormResendButton).tap();

      await r.verifyPIN(email);

      // Signup Screen One
      expect($('Welcome!'), findsOneWidget);

      final birthdate =
          DateTime(int.parse(birthYear), birthMonthNumber, int.parse(birthDay));
      final age = AgeCalculator.age(birthdate).years.toString();

      final dropdown = $(K.signUpBirthdateDropdown);
      await dropdown.$('January').tap();
      await $(birthMonth).scrollTo().tap();
      await dropdown.$('1').tap();
      await $(birthDay).scrollTo().tap();
      await dropdown.$('2008').tap();
      await $(birthYear).scrollTo().tap();
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
      expect($(age), findsOneWidget); // Birthdate => Age
      expect($(Icons.male), findsOneWidget);
      expect($('United States'), findsOneWidget);
      expect($('English'), findsOneWidget);
      await $(K.privateProfileEditBtn).tap();

      // Edit Profile Page
      expect($('Edit Profile'), findsWidgets);
      expect($(K.editProfileAvatarField), findsOneWidget);
      expect($(K.editProfileUsernameField).$(username), findsOneWidget);
      expect($(K.editProfileBirthdateField).$(birthMonth), findsOneWidget);
      expect($(K.editProfileBirthdateField).$(birthDay), findsOneWidget);
      expect($(K.editProfileBirthdateField).$(birthYear), findsOneWidget);

      const updatedUsername = 'otherFake';
      const updatedBirthMonth = 'April';
      const updatedBirthMonthNumber = 4;
      const updatedBirthDay = '7';
      const updatedBirthYear = '1998';
      final updatedBirthdate = DateTime(int.parse(updatedBirthYear),
          updatedBirthMonthNumber, int.parse(updatedBirthDay));
      const updatedBio = 'I am aweseome, hahaha!';
      const updatedCountry = 'Argentina';
      const updatedLanguage = 'Deutsch';
      final updatedAge = AgeCalculator.age(updatedBirthdate).years.toString();

      await $(K.editProfileUsernameField).enterText(updatedUsername);
      final birthDateDropdown = $(K.editProfileBirthdateField);
      await birthDateDropdown.$(birthMonth).tap();
      await $(updatedBirthMonth).scrollTo().tap();
      await birthDateDropdown.$(birthDay).tap();
      await $(updatedBirthDay).scrollTo().tap();
      await birthDateDropdown.$(birthYear).tap();
      await $(updatedBirthYear).scrollTo().tap();
      await $(K.editProfileBioField).enterText(updatedBio);
      await $(K.editProfileCountryField).scrollTo().tap();
      await $(updatedCountry).tap();
      await $(K.editProfileLanguageField).scrollTo().tap();
      await $(updatedLanguage).scrollTo().tap();
      await $(K.editProfileSaveButton).tap();

      // Private Profile Page
      expect($('Profile'), findsWidgets);
      expect($(updatedUsername), findsOneWidget);
      expect($(updatedAge), findsOneWidget);
      expect($(updatedCountry), findsOneWidget);
      expect($(updatedLanguage), findsOneWidget);
      expect($(updatedBio), findsOneWidget);
      await $(K.privateProfileInkWellToPublicProfile).tap();

      // Public Profile Page
      expect($(K.publicProfile), findsOneWidget);
      expect($(K.publicProfileAvatarCoverImg), findsOneWidget);
      expect($(updatedUsername), findsOneWidget);
      expect($(updatedAge), findsOneWidget);
      expect($(updatedCountry), findsOneWidget);
      expect($(updatedBio), findsOneWidget);
      await $(K.publicProfileBackButton).tap();

      // Logout
      await $(K.privateProfileSettingsBtn).tap();
      await $(K.settingsLogoutTile).tap();

      expect($('Sign Up').exists, equals(true));

      // Toggle to Login Form
      await $(K.authFormTypeToggle).tap();
      expect($('Log In').exists, equals(true));

      // Login
      await $(K.authFormEmailField).enterText(email);
      await $(K.authFormPasswordField).enterText(password);
      await $(K.authFormSubmitButton).tap();

      expect($('Explore'), findsWidgets);

      // Double check after login, profile info still correct
      await $(K.profileTab).tap();
      expect($('Profile'), findsWidgets);
      expect($(updatedUsername), findsOneWidget);
      expect($(updatedAge), findsOneWidget);
      expect($(updatedCountry), findsOneWidget);
      expect($(updatedLanguage), findsOneWidget);
      expect($(updatedBio), findsOneWidget);
    },
  );
}
