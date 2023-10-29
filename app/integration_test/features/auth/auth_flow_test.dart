import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import '../../robot.dart';

void main() {
  patrolTest(
    'login successfully',
    ($) async {
      final r = Robot($: $);
      await r.pumpAndSettleMyApp();

      expect($('Log In'), findsOneWidget);

      await $(TextField).containing('Email').enterText('jarvis@test.com');
      await $(TextField).containing('Password').enterText('secret');
      await $(ElevatedButton).containing('Login').tap();

      expect($('Contacts'), findsWidgets);
    },
  );
}
