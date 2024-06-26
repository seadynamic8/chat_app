import 'dart:async';

import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat_lobby/domain/chat_lobby_item_state.dart';
import 'package:chat_app/features/chat_lobby/domain/room.dart';
import 'package:chat_app/features/home/application/current_user_id_provider.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:chat_app/utils/pagination.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_lobby_repository.g.dart';

class ChatLobbyRepository {
  ChatLobbyRepository({required this.supabase});

  final SupabaseClient supabase;

  // * Find room if already exist
  Future<Room?> findRoomByProfiles({
    required String currentProfileId,
    required String otherProfileId,
  }) async {
    try {
      final room = await supabase
          .from('rooms')
          .select('id, c1:chat_users!inner(), c2:chat_users!inner()')
          .eq('c1.profile_id', currentProfileId)
          .eq('c2.profile_id', otherProfileId);

      if (room.isEmpty) return null;

      return Room.fromMap(room.first);
    } catch (error, st) {
      logger.error('findRoomByProfiles()', error, st);
      rethrow;
    }
  }

  // * Create Room
  Future<Room> createRoom() async {
    try {
      final roomResponse =
          await supabase.from('rooms').insert({}).select('id').single();

      return Room.fromMap(roomResponse);
    } catch (error, st) {
      logger.error('createRoom()', error, st);
      rethrow;
    }
  }

  Future<void> addUserToRoom({
    required String profileId,
    required String roomId,
    bool joined = false,
  }) async {
    try {
      await supabase.from('chat_users').insert({
        'profile_id': profileId,
        'room_id': roomId,
        'joined': joined,
      });
    } catch (error, st) {
      logger.error('addUserToRoom()', error, st);
      rethrow;
    }
  }

  // * Rooms Listing for user

  Future<List<Room>> getAllRooms({
    required String currentUserId,
    required int page,
    required int range,
  }) async {
    try {
      final (from: from, to: to) =
          getPagination(page: page, defaultRange: range);

      // messages table is just to sort the rooms by message creation date
      final roomsList = await supabase
          .from('chat_users')
          .select('''
            id:room_id, messages:room_id ()
          ''')
          .eq('profile_id', currentUserId)
          .eq('joined', true)
          .range(from, to)
          .order('created_at', referencedTable: 'messages');

      return roomsList.map((room) => Room.fromMap(room)).toList();
    } catch (error, st) {
      logger.error('getAllRooms()', error, st);
      rethrow;
    }
  }

  Future<List<Room>> getUnReadRooms({
    required String currentUserId,
    required int page,
    required int range,
  }) async {
    final (from: from, to: to) = getPagination(page: page, defaultRange: range);

    try {
      final roomsList = await supabase
          .from('un_read_joined_rooms')
          .select('id:room_id, last_unread_at')
          .order('last_unread_at', ascending: false)
          .range(from, to);

      return roomsList.map((room) => Room.fromMap(room)).toList();
    } catch (error, st) {
      logger.error('getUnReadRooms()', error, st);
      rethrow;
    }
  }

  Future<List<Room>> getRequestedRooms({
    required String currentUserId,
    required int page,
    required int range,
  }) async {
    final (from: from, to: to) = getPagination(page: page, defaultRange: range);

    try {
      final roomsList = await supabase
          .from('chat_users')
          .select('id:room_id')
          .eq('profile_id', currentUserId)
          .eq('joined', false)
          .order('created_at', ascending: false)
          .range(from, to);

      return roomsList.map((room) => Room.fromMap(room)).toList();
    } catch (error, st) {
      logger.error('getRequestedRooms()', error, st);
      rethrow;
    }
  }

  // * Room Detail for each room

  Future<ChatLobbyItemState> getChatLobbyItemState(
    String roomId,
    String currentProfileId,
  ) async {
    try {
      final chatLobbyItemResponse = await supabase
          .from('rooms')
          .select('''
          messages (id, profile_id, content, translation, type, created_at),
          profiles!inner (id, username, avatar_url, language)
        ''')
          .eq('id', roomId)
          .neq('profiles.id', currentProfileId)
          .order('created_at', referencedTable: 'messages', ascending: false)
          .limit(1, referencedTable: 'messages');

      if (chatLobbyItemResponse.isEmpty) return ChatLobbyItemState();

      final chatLobbyItem = chatLobbyItemResponse.first;

      return ChatLobbyItemState(
        otherProfile: Profile.fromMap(chatLobbyItem['profiles'].first),
        newestMessage: chatLobbyItem['messages'].isNotEmpty
            ? Message.fromMap(chatLobbyItem['messages'].first)
            : null,
      );
    } catch (error, st) {
      logger.error('getChatLobbyItemState()', error, st);
      rethrow;
    }
  }

  // * Watch for new unread messages

  Stream<int> watchUnReadMessagesCount({
    required String profileId,
    String? roomId,
  }) {
    final messagesStream = supabase
        .from('messages_users')
        .stream(primaryKey: ['message_id', 'profile_id'])
        .eq('profile_id', profileId)
        .order('created_at', ascending: false)
        .limit(1000);

    // Unfortunately supabase streams only can have one filter
    // so we need to filter more here
    return messagesStream.map((messages) {
      return messages
          .where((message) =>
              !message['read'] &&
              (roomId == null ? true : message['room_id'] == roomId))
          .toList()
          .length;
    });
  }

  Stream<Message> watchMessagesUsersInsert(String currentUserId) {
    final streamController = StreamController<Message>();

    supabase
        .channel('public:messages_users:insert:profile_id=eq.$currentUserId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages_users',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'profile_id',
            value: currentUserId,
          ),
          callback: (PostgresChangePayload payload) async {
            final messagesUser = payload.newRecord;
            streamController.add(Message.fromMap(messagesUser));
          },
        )
        .subscribe();

    return streamController.stream;
  }

  Stream<Message> watchMessagesUsersUpdate(String currentUserId) {
    final streamController = StreamController<Message>();

    supabase
        .channel('public:messages_users:update:profile_id=eq.$currentUserId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'messages_users',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'profile_id',
            value: currentUserId,
          ),
          callback: (PostgresChangePayload payload) async {
            final messagesUser = payload.newRecord;
            streamController.add(Message.fromMap(messagesUser));
          },
        )
        .subscribe();

    return streamController.stream;
  }
}

@riverpod
ChatLobbyRepository chatLobbyRepository(ChatLobbyRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  return ChatLobbyRepository(supabase: supabase);
}

@riverpod
FutureOr<Room?> findRoomWithUser(
    FindRoomWithUserRef ref, String otherProfileId) {
  final currentProfileId = ref.watch(currentUserIdProvider);
  if (currentProfileId == null) {
    throw Exception('Unable to find room, user not signed in');
  }
  final chatLobbyRepository = ref.watch(chatLobbyRepositoryProvider);
  return chatLobbyRepository.findRoomByProfiles(
      currentProfileId: currentProfileId, otherProfileId: otherProfileId);
}

@riverpod
FutureOr<List<Room>> allRooms(AllRoomsRef ref, int page, int range) async {
  final currentUserId = ref.watch(currentUserIdProvider);
  if (currentUserId == null) return [];

  final chatLobbyRepository = ref.watch(chatLobbyRepositoryProvider);
  return await chatLobbyRepository.getAllRooms(
    currentUserId: currentUserId,
    page: page,
    range: range,
  );
}

@riverpod
FutureOr<List<Room>> unReadOnlyRooms(
    UnReadOnlyRoomsRef ref, int page, int range) async {
  final currentUserId = ref.watch(currentUserIdProvider);
  if (currentUserId == null) return [];

  final chatLobbyRepository = ref.watch(chatLobbyRepositoryProvider);
  return await chatLobbyRepository.getUnReadRooms(
    currentUserId: currentUserId,
    page: page,
    range: range,
  );
}

@riverpod
FutureOr<List<Room>> requestedRooms(
    RequestedRoomsRef ref, int page, int range) async {
  final currentUserId = ref.watch(currentUserIdProvider);
  if (currentUserId == null) return [];

  final chatLobbyRepository = ref.watch(chatLobbyRepositoryProvider);
  return await chatLobbyRepository.getRequestedRooms(
    currentUserId: currentUserId,
    page: page,
    range: range,
  );
}

@riverpod
Stream<Message> messagesUsersInsert(MessagesUsersInsertRef ref) {
  final currentUserId = ref.watch(currentUserIdProvider)!;
  final chatLobbyRepository = ref.watch(chatLobbyRepositoryProvider);
  return chatLobbyRepository.watchMessagesUsersInsert(currentUserId);
}

@riverpod
Stream<Message> messagesUsersUpdate(MessagesUsersUpdateRef ref) {
  final currentUserId = ref.watch(currentUserIdProvider)!;
  final chatLobbyRepository = ref.watch(chatLobbyRepositoryProvider);
  return chatLobbyRepository.watchMessagesUsersUpdate(currentUserId);
}

@riverpod
Stream<Room> newUnReadRoom(NewUnReadRoomRef ref) {
  final streamController = StreamController<Room>();
  ref.watch(messagesUsersInsertProvider).whenData((message) {
    if (message.read == false) {
      streamController.add(Room(id: message.roomId!));
    }
  });
  return streamController.stream;
}

@riverpod
Stream<Room> newUnReadJoinedRoom(NewUnReadJoinedRoomRef ref) {
  final streamController = StreamController<Room>();
  ref.watch(newUnReadRoomProvider).whenData((room) async {
    final currentUserId = ref.read(currentUserIdProvider)!;
    // we need the latest join status here, so can't put in cached provider
    // unless its a stream that updates
    final roomJoined = await ref
        .read(chatRepositoryProvider)
        .getJoinStatus(room.id, currentUserId);
    if (roomJoined) streamController.add(room);
  });
  return streamController.stream;
}

@riverpod
Stream<Room> newReadRoom(NewReadRoomRef ref) {
  final streamController = StreamController<Room>();
  ref.watch(messagesUsersUpdateProvider).whenData((message) {
    if (message.read == true) {
      streamController.add(Room(id: message.roomId!));
    }
  });
  return streamController.stream;
}

@riverpod
Stream<int> unReadMessageCountStream(UnReadMessageCountStreamRef ref,
    [String? roomId]) {
  final currentProfileId = ref.watch(currentUserIdProvider);
  if (currentProfileId == null) return Stream.value(0);

  final chatLobbyRepository = ref.watch(chatLobbyRepositoryProvider);
  return chatLobbyRepository.watchUnReadMessagesCount(
      profileId: currentProfileId, roomId: roomId);
}
