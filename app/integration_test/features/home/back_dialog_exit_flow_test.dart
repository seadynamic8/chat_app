import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import '../../app_initializer.dart';
import '../../common/auth_admin_repository.dart';
import '../../robot.dart';

void main() {
  const email = 'fake@test.com';
  const password = 'fake1234';
  late final AuthAdminRepository authAdminRepository;
  late final AuthRepository authRepository;

  setUp(() async {
    await AppInitializer().setup();
    authAdminRepository = AuthAdminRepository();
    authRepository = ProviderContainer().read(authRepositoryProvider);

    await authAdminRepository.deleteUserByEmail(email);
    await authAdminRepository.createUser(email: email, password: password);

    await authRepository.signInWithEmailAndPassword(
        email: email, password: password);
  });

  tearDown(() async {
    await authAdminRepository.deleteUserByEmail(email);
  });

  patrolTest('forgot password', ($) async {
    final r = Robot($: $);
    await r.pumpAndSettleMyApp(preSetup: false);

    expect($('Explore').exists, equals(true));

    // * Test broken for now because the native pressBack doesn't seem to work
    // * Only worked for Android anyway, iPhone doesn't have a back button.

    // await $.native.pressBack();

    // expect($('Please confirm'), findsOneWidget);

    // await $('No').tap();

    // expect($('Please confirm'), findsNothing);
    // expect($('Explore').exists, equals(true));

    // await $.native.pressBack();

    // expect($('Please confirm'), findsOneWidget);

    // await $('Yes').tap();

    // expect($('Please confirm'), findsNothing);
    // expect($('Explore'), findsNothing);
  }, skip: true);
}
