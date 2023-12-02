import 'dart:async';
import 'dart:ui';

import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/domain/room.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:patrol/patrol.dart';

import '../../app_initializer.dart';
import '../../mocks.dart';
import '../../robot.dart';
import '../../test_helper.dart';

void main() {
  const email = 'fake@test.com';
  const password = 'fake1234';
  const fakeRoomOneId = 'fakeRoom1';
  const fakeRoomTwoId = 'fakeRoom2';
  const fakeUserOneId = '1234';
  const fakeUserOneUsername = 'fakeOtherUser1';
  const fakeUserTwoUsername = 'fakeOtherUser2';
  final fakeRooms = [
    Room(
      id: fakeRoomOneId,
      otherProfile: const Profile(
        id: fakeUserOneId,
        username: fakeUserOneUsername,
        language: Locale('en'),
      ),
    ),
    Room(
      id: fakeRoomTwoId,
      otherProfile: const Profile(
        id: '4567',
        username: fakeUserTwoUsername,
        language: Locale('en'),
      ),
    )
  ];
  const unReadCountOne = 25;
  const unReadCountTwo = 5;
  var totalCount = 0;
  final streamControllerOne = StreamController<int>();
  final streamControllerTwo = StreamController<int>();
  final streamControllerTotal = StreamController<int>();

  late final TestHelper t;
  late final MockChatRepository chatRepository;
  late final String currentProfileId;

  setUp(() async {
    await AppInitializer().setup();
    t = TestHelper();
    currentProfileId =
        await t.createAndLoginUser(email: email, password: password);
    chatRepository = MockChatRepository();
  });

  tearDown(() async {
    await t.clearUser(email: email);
  });

  patrolTest('unread messages flow', ($) async {
    final r = Robot($: $);
    final overrides = [
      chatRepositoryProvider.overrideWithValue(chatRepository)
    ];
    when(() => chatRepository.getAllRoomsByUser(currentProfileId))
        .thenAnswer((_) => Future.value(fakeRooms));

    when(() => chatRepository.watchUnReadMessages(profileId: currentProfileId))
        .thenAnswer((_) => streamControllerTotal.stream);

    when(() => chatRepository.watchUnReadMessages(
          profileId: currentProfileId,
          roomId: fakeRoomOneId,
        )).thenAnswer((_) => streamControllerOne.stream);
    when(() => chatRepository.watchUnReadMessages(
          profileId: currentProfileId,
          roomId: fakeRoomTwoId,
        )).thenAnswer((_) => streamControllerTwo.stream);

    when(() => chatRepository.getProfilesForRoom(fakeRoomOneId))
        .thenAnswer((_) => Future.value({
              fakeUserOneId: const Profile(
                id: fakeUserOneId,
                username: fakeUserOneUsername,
              ),
            }));
    when(() => chatRepository.getAllMessagesForRoom(fakeRoomOneId, 0, 30))
        .thenAnswer((_) => Future.value([]));
    when(() => chatRepository.markAllMessagesAsReadForRoom(
        fakeRoomOneId, currentProfileId)).thenAnswer((_) => Future.value());

    // START APP
    await r.pumpAndSettleMyApp(preSetup: false, overrides: overrides);

    // PRELOAD UNREAD COUNT ONE
    streamControllerOne.add(unReadCountOne);
    totalCount += unReadCountOne;
    streamControllerTotal.add(totalCount);
    await $.pumpAndSettle();

    expect($('Explore').exists, equals(true));
    expect($(K.chatsTab).$((totalCount).toString()).exists, equals(true));

    // VISIT CHATS TAB
    await $(K.chatsTab).tap();

    expect($('Chats').exists, equals(true));
    expect($(unReadCountOne.toString()).exists, equals(true));
    expect($(K.chatsTab).$((totalCount).toString()).exists, equals(true));

    streamControllerTwo.add(unReadCountTwo);
    totalCount += unReadCountTwo;
    streamControllerTotal.add(totalCount);
    await $.pumpAndSettle();

    expect($(K.chatLobbyUnReadMessageCount), findsWidgets);
    expect($(unReadCountOne.toString()).exists, equals(true));
    expect($(unReadCountTwo.toString()).exists, equals(true));
    expect($(K.chatsTab).$((totalCount).toString()).exists, equals(true));

    // VISIT FIRST FAKE USER
    await $(fakeUserOneUsername).tap();

    expect($(fakeUserOneUsername).exists, equals(true));

    // MARKED READ FIRST USER UNREAD MESSAGES
    streamControllerOne.add(0);
    totalCount -= unReadCountOne;
    streamControllerTotal.add(totalCount);
    await $.pumpAndSettle();

    // GO BACK TO CHAT LOBBY
    await $.tester.pageBack();
    await $.pumpAndSettle();

    expect($('Chats').exists, equals(true));
    expect($(unReadCountOne.toString()).exists, equals(false));
    expect($(K.chatsTab).$((totalCount).toString()).exists, equals(true));
  });
}
