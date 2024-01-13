import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat_lobby/data/chat_lobby_repository.dart';
import 'package:chat_app/features/chat_lobby/view/chat_lobby_item.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import '../../app_initializer.dart';
import '../../robot.dart';
import '../../test_helper.dart';

void main() {
  const email = 'fake@test.com';
  const password = 'fake1234';
  late String fakeUserOneId;
  late String fakeUserTwoId;
  const fakeUserOneEmail = 'fakeUserOne@test.com';
  const fakeUserTwoEmail = 'fakeUserTwo@test.com';
  const fakeUserOneUsername = 'fakeOtherUser1';
  const fakeUserTwoUsername = 'fakeOtherUser2';

  late final TestHelper t;
  late final ChatLobbyRepository chatLobbyRepository;
  late final ChatRepository chatRepository;
  late final String currentProfileId;

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
    fakeUserTwoId = await t.createUser(
      email: fakeUserTwoEmail,
      password: password,
      username: fakeUserTwoUsername,
    );
    chatLobbyRepository = ProviderContainer().read(chatLobbyRepositoryProvider);
    chatRepository = ProviderContainer().read(chatRepositoryProvider);
  });

  tearDown(() async {
    await t.clearUser(email: email);
    await t.clearUser(email: fakeUserOneEmail);
    await t.clearUser(email: fakeUserTwoEmail);
  });

  patrolTest('chat lobby flow', ($) async {
    final r = Robot($: $);

    await r.pumpAndSettleMyApp(preSetup: false);

    expect($(K.chatsBadgeTab), findsNothing);

    await $(K.chatsTab).tap();

    expect($(ChatLobbyItem), findsNothing);

    await $(K.exploreTab).tap();

    expect($('Explore'), findsWidgets);
    await $(K.exploreScreenSearchButton).tap();

    expect($(K.searchScreen), findsOneWidget);
    await $(K.searchScreenSearchField).enterText(fakeUserOneUsername);
    await $(K.searchScreenResultTile).$(fakeUserOneUsername).tap();

    expect($(K.publicProfile), findsOneWidget);
    await $(K.publicProfileSendMsgButton).tap();

    expect($(K.chatRoom), findsOneWidget);
    await r.goBack();

    // FAKE ROOM ONE CREATED, FIND ID
    final fakeRoomOne = await chatLobbyRepository.findRoomByProfiles(
        currentProfileId: currentProfileId, otherProfileId: fakeUserOneId);
    final fakeRoomOneId = fakeRoomOne!.id;
    final chatLobbyItemTileFakeRoomOne =
        ValueKey('${K.chatLobbyItemTilePrefix}$fakeRoomOneId');

    expect($('Chats').exists, equals(true));
    // Expect chat lobby item (username, avatar, no newest message, no newest message timestamp, no unread message)
    expect(
        $(chatLobbyItemTileFakeRoomOne).$(K.chatLobbyItemAvatar), findsWidgets);
    expect(
        $(chatLobbyItemTileFakeRoomOne).$(fakeUserOneUsername), findsOneWidget);
    expect($(chatLobbyItemTileFakeRoomOne).$(K.chatLobbyItemNewestMsg),
        findsNothing);
    expect($(chatLobbyItemTileFakeRoomOne).$(K.chatLobbyItemNewestMsgTime),
        findsNothing);
    expect($(K.chatLobbyItemUnReadMsgCount), findsNothing);

    await $(chatLobbyItemTileFakeRoomOne).tap();

    expect($(K.chatRoom), findsOneWidget);
    // Send initial message
    const myMessageOne = 'hey';
    await $(K.chatRoomNewMessageField).enterText(myMessageOne);
    await $(K.chatRoomSendNewMessageBtn).tap();
    expect($(K.chatRoomMessages).$(myMessageOne), findsWidgets);
    await r.goBack();

    expect($('Chats').exists, equals(true));
    // Expect chat lobby item (username, avatar, newest message, newest message timestamp, no unread message)
    expect(
        $(chatLobbyItemTileFakeRoomOne).$(fakeUserOneUsername), findsOneWidget);
    expect(
        $(chatLobbyItemTileFakeRoomOne)
            .$(K.chatLobbyItemNewestMsg)
            .$(myMessageOne),
        findsOneWidget);
    expect($(chatLobbyItemTileFakeRoomOne).$(K.chatLobbyItemNewestMsgTime),
        findsWidgets);
    expect($(chatLobbyItemTileFakeRoomOne).$(K.chatLobbyItemUnReadMsgCount),
        findsNothing);

    // Mock - other user sends message to that chat room
    const fakeUserOneMessage = 'hello';
    await chatRepository.saveMessage(
      fakeRoomOneId,
      currentProfileId,
      Message(content: fakeUserOneMessage, profileId: fakeUserOneId),
    );
    await $.pumpAndSettle();
    // Add duration to see new timestamp, comment out because too long
    // await Future.delayed(const Duration(seconds: 46));
    // await $.pumpAndSettle();

    // Expect chat lobby item (newest message changed + timestamp, unread message count)
    expect(
        $(chatLobbyItemTileFakeRoomOne).$(fakeUserOneUsername), findsOneWidget);
    expect(
        $(chatLobbyItemTileFakeRoomOne)
            .$(K.chatLobbyItemNewestMsg)
            .$(myMessageOne),
        findsNothing);
    expect(
        $(chatLobbyItemTileFakeRoomOne)
            .$(K.chatLobbyItemNewestMsg)
            .$(fakeUserOneMessage),
        findsOneWidget);
    // Test updated timestamp, but don't want to slow down test, so comment out
    // expect(
    //     $(chatLobbyItemTileFakeRoomOne)
    //         .$(K.chatLobbyItemNewestMsgTime)
    //         .$('a minute ago'),
    //     findsWidgets);
    expect($(chatLobbyItemTileFakeRoomOne).$(K.chatLobbyItemUnReadMsgCount),
        findsOneWidget);
    expect($(chatLobbyItemTileFakeRoomOne).$('1'), findsOneWidget);
    expect($(K.chatsBadgeTab).$('1'), findsOneWidget);

    // Mock - otherUser2 enters chatRoom2 with you
    final fakeRoomTwo = await chatLobbyRepository.createRoom();
    final fakeRoomTwoId = fakeRoomTwo.id;
    await chatLobbyRepository.addUserToRoom(
        profileId: currentProfileId, roomId: fakeRoomTwoId, joined: true);
    await chatLobbyRepository.addUserToRoom(
        profileId: fakeUserTwoId, roomId: fakeRoomTwoId, joined: true);
    final chatLobbyItemTileFakeRoomTwo =
        ValueKey('${K.chatLobbyItemTilePrefix}$fakeRoomTwoId');
    await $.pumpAndSettle();

    // Expect chatLobbyItem2 (username, avatar, no newest message (or timestamp), no unread message)
    expect(
        $(chatLobbyItemTileFakeRoomTwo).$(fakeUserTwoUsername), findsOneWidget);
    expect($(chatLobbyItemTileFakeRoomTwo).$(K.chatLobbyItemNewestMsg),
        findsNothing);
    expect($(chatLobbyItemTileFakeRoomTwo).$(K.chatLobbyItemUnReadMsgCount),
        findsNothing);
    expect($(chatLobbyItemTileFakeRoomTwo).$('1'), findsNothing);
    expect($(K.chatsBadgeTab).$('1'), findsOneWidget);

    // Mock call - otherUser2 sends message to chatRoom2
    const fakeTwoMessageOne = 'how are you?';
    await chatRepository.saveMessage(
      fakeRoomTwoId,
      currentProfileId,
      Message(content: fakeTwoMessageOne, profileId: fakeUserTwoId),
    );
    await $.pumpAndSettle();

    // Expect chatLobbyItem2 changed (newest message and timestamp, unread message)
    expect(
        $(chatLobbyItemTileFakeRoomTwo).$(fakeUserTwoUsername), findsOneWidget);
    expect(
        $(chatLobbyItemTileFakeRoomTwo)
            .$(K.chatLobbyItemNewestMsg)
            .$(fakeTwoMessageOne),
        findsOneWidget);
    expect($(chatLobbyItemTileFakeRoomTwo).$(K.chatLobbyItemUnReadMsgCount),
        findsOneWidget);
    expect($(chatLobbyItemTileFakeRoomTwo).$('1'), findsOneWidget);
    expect($(K.chatsBadgeTab).$('2'), findsOneWidget);

    await $(chatLobbyItemTileFakeRoomOne).tap();

    expect($(K.chatRoomMessages).$(fakeUserOneMessage), findsOneWidget);
    await r.goBack();

    // Expect chatLobbyItem1 (no unread message)
    expect($(chatLobbyItemTileFakeRoomOne).$(K.chatLobbyItemUnReadMsgCount),
        findsNothing);
    expect($(K.chatsBadgeTab).$('1'), findsOneWidget);
  });
}
