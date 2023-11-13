import 'package:chat_app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import '../../robot.dart';

void main() {
  const email = 'test@test.com';
  // const username = 'test1234';
  const password = 'test1234';

  patrolTest(
    'login and logout flow',
    ($) async {
      final r = Robot($: $);
      await r.pumpAndSettleMyApp();

      expect($('Log In').exists, equals(true));

      // * Need to setup some type of database transaction using RPC and Postgres
      // * stored procedure to create and destroy users
      // // Switch to Sign Up form
      // await $(K.authFormTypeToggle).tap();
      // // Sign up
      // await $(K.authFormEmailField).enterText(email);
      // // await $(K.authFormUsernameField).enterText(username);
      // await $(K.authFormPasswordField).enterText(password);
      // await $(K.authFormSubmitButton).tap();

      // expect($('Contacts'), findsWidgets);

      // Logout
      // await $(K.profileTab).tap();
      // await $(IconButton).containing(Icons.settings).tap();
      // await $(ListTile).containing('Logout').tap();

      // expect($('Log In').exists, equals(true));

      // Login
      await $(K.authFormEmailField).enterText(email);
      await $(K.authFormPasswordField).enterText(password);
      await $(K.authFormSubmitButton).tap();

      expect($('Explore'), findsWidgets);

      // Logout
      await $(K.profileTab).tap();
      await $(IconButton).containing(Icons.settings).tap();
      await $(ListTile).containing('Logout').tap();

      expect($('Log In').exists, equals(true));
    },
  );
}
