import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat_lobby/domain/chat_lobby_item_state.dart';
import 'package:chat_app/features/chat_lobby/domain/room.dart';
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
          .select<List<Map<String, dynamic>>>(
              'id, c1:chat_users!inner(), c2:chat_users!inner()')
          .eq('c1.profile_id', currentProfileId)
          .eq('c2.profile_id', otherProfileId);

      if (room.isEmpty) return null;

      return Room.fromMap(room.first);
    } catch (error, st) {
      await logError('findRoomByProfiles()', error, st);
      rethrow;
    }
  }

  // * Create Room
  Future<Room> createRoom() async {
    try {
      final roomResponse = await supabase
          .from('rooms')
          .insert({})
          .select<Map<String, dynamic>>('id')
          .single();

      return Room.fromMap(roomResponse);
    } catch (error, st) {
      await logError('createRoom()', error, st);
      rethrow;
    }
  }

  Future<void> addUserToRoom(String profileId, String roomId) async {
    try {
      await supabase
          .from('chat_users')
          .insert({'profile_id': profileId, 'room_id': roomId});
    } catch (error, st) {
      await logError('addUserToRoom()', error, st);
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
          .from('rooms')
          .select<List<Map<String, dynamic>>>(
              'id, chat_users!inner (), messages ()')
          .eq('chat_users.profile_id', currentUserId)
          .range(from, to)
          .order('created_at', foreignTable: 'messages');

      return roomsList.map((room) => Room.fromMap(room)).toList();
    } catch (error, st) {
      await logError('getAllRooms()', error, st);
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
          .from('un_read_rooms')
          .select<List<Map<String, dynamic>>>('''
            id:room_id,
            last_unread_at
          ''')
          .order('last_unread_at', ascending: false)
          .range(from, to);

      return roomsList.map((room) => Room.fromMap(room)).toList();
    } catch (error, st) {
      await logError('getUnReadRooms()', error, st);
      rethrow;
    }
  }

  // * Room Detail for each room

  Future<ChatLobbyItemState?> getChatLobbyItemState(
    String roomId,
    String currentProfileId,
  ) async {
    try {
      final chatLobbyItemResponse = await supabase
          .from('rooms')
          .select<List<Map<String, dynamic>>>('''
          messages (id, profile_id, content, translation, type, created_at),
          profiles!inner (id, username, avatar_url, language)
        ''')
          .eq('id', roomId)
          .neq('profiles.id', currentProfileId)
          .order('created_at', foreignTable: 'messages', ascending: false)
          .limit(1, foreignTable: 'messages');

      if (chatLobbyItemResponse.isEmpty) {
        logger.w(
            'Chat Lobby Item is empty, probably other user has been deleted and removed from room');
        return null;
      }
      final chatLobbyItem = chatLobbyItemResponse.first;

      return ChatLobbyItemState(
        otherProfile: Profile.fromMap(chatLobbyItem['profiles'].first),
        newestMessage: chatLobbyItem['messages'].isNotEmpty
            ? Message.fromMap(chatLobbyItem['messages'].first)
            : null,
      );
    } catch (error, st) {
      await logError('getChatLobbyItemState()', error, st);
      rethrow;
    }
  }

  // * Watch for new room

  void watchNewRoomForUser(
      String currentUserId, void Function(Room newRoom) callback) {
    supabase.channel('public:chat_users:profile_id=eq.$currentUserId').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: 'INSERT',
        schema: 'public',
        table: 'chat_users',
        filter: 'profile_id=eq.$currentUserId',
      ),
      (payload, [ref]) async {
        final chatUser = payload['new'];

        callback(Room(id: chatUser['room_id']));
      },
    ).subscribe();
  }

  // * Watch for new unread messages

  Stream<int> watchUnReadMessages({
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

  void watchNewUnReadMessage(
      String currentUserId, void Function(Room newRoom) callback) {
    supabase
        .channel('public:messages_users:insert:profile_id=eq.$currentUserId')
        .on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: 'INSERT',
        schema: 'public',
        table: 'messages_users',
        filter: 'profile_id=eq.$currentUserId',
      ),
      (payload, [ref]) async {
        final message = payload['new'];

        if (!message['read']) {
          callback(Room(id: message['room_id']));
        }
      },
    ).subscribe();
  }

  void watchNewReadMessage(
      String currentUserId, void Function(Room newRoom) callback) {
    supabase
        .channel('public:messages_users:update:profile_id=eq.$currentUserId')
        .on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: 'UPDATE',
        schema: 'public',
        table: 'messages_users',
        filter: 'profile_id=eq.$currentUserId',
      ),
      (payload, [ref]) async {
        final message = payload['new'];

        if (message['read']) {
          callback(Room(id: message['room_id']));
        }
      },
    ).subscribe();
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
  final currentProfileId = ref.watch(currentUserIdProvider)!;
  final chatLobbyRepository = ref.watch(chatLobbyRepositoryProvider);
  return chatLobbyRepository.findRoomByProfiles(
      currentProfileId: currentProfileId, otherProfileId: otherProfileId);
}

@riverpod
FutureOr<List<Room>> allRooms(AllRoomsRef ref, int page, int range) async {
  final currentUserId = ref.watch(currentUserIdProvider)!;
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
  final currentUserId = ref.watch(currentUserIdProvider)!;
  final chatLobbyRepository = ref.watch(chatLobbyRepositoryProvider);
  return await chatLobbyRepository.getUnReadRooms(
    currentUserId: currentUserId,
    page: page,
    range: range,
  );
}

@riverpod
Stream<int> unReadMessageCountStream(UnReadMessageCountStreamRef ref,
    [String? roomId]) {
  final currentProfileId = ref.watch(currentUserIdProvider)!;
  final chatLobbyRepository = ref.watch(chatLobbyRepositoryProvider);
  return chatLobbyRepository.watchUnReadMessages(
      profileId: currentProfileId, roomId: roomId);
}
