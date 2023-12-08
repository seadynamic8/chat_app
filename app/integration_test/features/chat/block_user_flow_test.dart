import 'package:chat_app/utils/keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import '../../app_initializer.dart';
import '../../robot.dart';
import '../../test_helper.dart';

void main() {
  const email = 'fake@test.com';
  const password = 'fake1234';
  late String fakeUserOneId;
  const fakeUserOneEmail = 'fakeUserOne@test.com';
  const fakeUserOneUsername = 'fakeOtherUser1';
  late String fakeRoomOneId;

  late final TestHelper t;
  late String currentProfileId;

  setUp(() async {
    await AppInitializer().setup();
    t = TestHelper();
    currentProfileId =
        await t.createAndLoginUser(email: email, password: password);
    fakeUserOneId = await t.createUser(
      email: fakeUserOneEmail,
      password: password,
      username: fakeUserOneUsername,
    );
    final fakeRoomOne = await t.createAndJoinRoom(fakeUserOneId);
    fakeRoomOneId = fakeRoomOne.id;
  });

  tearDown(() async {
    await t.destroyRoom(fakeRoomOneId);
    await t.clearUser(email: email);
    await t.clearUser(email: fakeUserOneEmail);
  });

  patrolTest('block user flow', ($) async {
    final r = Robot($: $);

    final chatLobbyItemTileFakeRoomOne =
        ValueKey('${K.chatLobbyItemTilePrefix}$fakeRoomOneId');

    await r.pumpAndSettleMyApp(preSetup: false);

    await $(K.chatsTab).tap();

    await $(chatLobbyItemTileFakeRoomOne).tap();

    expect($(K.chatRoom), findsOneWidget);

    // Send initial message
    const myMessage1 = 'hey';
    await $(K.chatRoomNewMessageField).enterText(myMessage1);
    await $(K.chatRoomSendNewMessageBtn).tap();
    expect($(K.chatRoomMessages).$(myMessage1), findsWidgets);

    // Block other user
    await $(K.chatRoomMoreOptionsButton).tap();
    expect($(K.chatRoomBlockToggleButton).$('Block'), findsOneWidget);
    await $(K.chatRoomBlockToggleButton).tap();
    await $.pumpAndSettle(); // For some reason, the tap earlier didn't settle.

    expect($(K.chatRoomMessages).$('You have blocked the other user'),
        findsOneWidget);

    // Try sending message when blocked
    const myMessage2 = 'hey2';
    await $(K.chatRoomNewMessageField).enterText(myMessage2);
    await $(K.chatRoomSendNewMessageBtn).tap();
    expect($(K.chatRoomMessages).$(myMessage2), findsNothing);
    expect(
        $(K.snackBar).$('You have blocked the other user, cannot send message'),
        findsOneWidget);

    // Can't mock onlinePresences for now.. so no way to test video call for now
    // Try video call when blocked
    // await $(K.chatRoomVideoCallButton).tap();
    // expect(
    //     $(K.snackBar).$('You have blocked the other user, cannot send message'),
    //     findsOneWidget);

    await $(K.chatRoomMoreOptionsButton).tap();
    expect($(K.chatRoomBlockToggleButton).$('Unblock'), findsOneWidget);
    await $(K.chatRoomBlockToggleButton).tap();
    await $.pumpAndSettle();
    expect($(K.chatRoomMessages).$('You have unblocked the other user'),
        findsOneWidget);

    // Try sending message when you unblocked
    const myMessage3 = 'hey3';
    await $(K.chatRoomNewMessageField).enterText(myMessage3);
    await $(K.chatRoomSendNewMessageBtn).tap();
    expect($(K.chatRoomMessages).$(myMessage3), findsOneWidget);
    expect(
        $(K.snackBar).$('You have blocked the other user, cannot send message'),
        findsNothing);

    // Reblock the other user
    await $(K.chatRoomMoreOptionsButton).tap();
    expect($(K.chatRoomBlockToggleButton).$('Block'), findsOneWidget);
    await $(K.chatRoomBlockToggleButton).tap();
    await $.pumpAndSettle();
    expect($(K.chatRoomMessages).$('You have blocked the other user'),
        findsWidgets);

    // Mock - other user blocks you
    await t.blockUser(fakeRoomOneId, fakeUserOneId, currentProfileId);
    await $.pumpAndSettle();
    expect($(K.chatRoomMessages).$('The other user has blocked you'),
        findsOneWidget);

    // Try sending message after both of you have blocked each other.
    const myMessage4 = 'hey4';
    await $(K.chatRoomNewMessageField).enterText(myMessage4);
    await $(K.chatRoomSendNewMessageBtn).tap();
    expect($(K.chatRoomMessages).$(myMessage4), findsNothing);
    expect(
        $(K.snackBar).$(
            'Both you and the other user has blocked each other, cannot send message'),
        findsOneWidget);

    // You unblock the other user
    await $(K.chatRoomMoreOptionsButton).tap();
    expect($(K.chatRoomBlockToggleButton).$('Unblock'), findsOneWidget);
    await $(K.chatRoomBlockToggleButton).tap();
    await $.pumpAndSettle();
    expect($(K.chatRoomMessages).$('You have unblocked the other user'),
        findsWidgets);

    // Try sending message when you unblocked, but other user has blocked you
    const myMessage5 = 'hey5';
    await $(K.chatRoomNewMessageField).enterText(myMessage5);
    await $(K.chatRoomSendNewMessageBtn).tap();
    expect($(K.chatRoomMessages).$(myMessage5), findsNothing);
    expect(
        $(K.snackBar).$('The other user has blocked you, cannot send message'),
        findsOneWidget);

    // Mock - other user unblocks you
    await t.unBlockUser(fakeRoomOneId, fakeUserOneId, currentProfileId);
    await $.pumpAndSettle();
    expect($(K.chatRoomMessages).$('The other user has unblocked you'),
        findsOneWidget);

    // Try sending message when both unblocked.
    const myMessage6 = 'hey6';
    await $(K.chatRoomNewMessageField).enterText(myMessage6);
    await $(K.chatRoomSendNewMessageBtn).tap();
    expect($(K.chatRoomMessages).$(myMessage6), findsOneWidget);
    expect(
        $(K.snackBar).$('The other user has blocked you, cannot send message'),
        findsNothing);
  });
}
