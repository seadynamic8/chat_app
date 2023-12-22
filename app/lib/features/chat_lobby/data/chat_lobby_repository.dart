import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat_lobby/domain/chat_lobby_item_state.dart';
import 'package:chat_app/features/chat_lobby/domain/room.dart';
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
    final room = await supabase
        .from('rooms')
        .select<List<Map<String, dynamic>>>(
            'id, c1:chat_users!inner(), c2:chat_users!inner()')
        .eq('c1.profile_id', currentProfileId)
        .eq('c2.profile_id', otherProfileId);

    if (room.isEmpty) return null;

    return Room.fromMap(room.first);
  }

  // * Create Room
  Future<Room> createRoom() async {
    final roomResponse = await supabase
        .from('rooms')
        .insert({})
        .select<Map<String, dynamic>>('id')
        .single();

    return Room.fromMap(roomResponse);
  }

  Future<void> addUserToRoom(String profileId, String roomId) async {
    await supabase
        .from('chat_users')
        .insert({'profile_id': profileId, 'room_id': roomId});
  }

  // * Rooms Listing for user

  Future<List<Room>> getAllRooms(
      String currentUserId, int page, int range) async {
    final (from: from, to: to) = getPagination(page: page, defaultRange: range);

    final roomsList = await supabase
        .from('rooms')
        .select<List<Map<String, dynamic>>>(
            'id, chat_users!inner (), messages ()')
        .eq('chat_users.profile_id', currentUserId)
        .range(from, to)
        .order('created_at', foreignTable: 'messages');

    return roomsList.map((room) => Room.fromMap(room)).toList();
  }

  // * Room Detail for each room

  Future<ChatLobbyItemState> getChatLobbyItemState(
    String roomId,
    String currentProfileId,
  ) async {
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
      throw Exception(
          'chatLobbyItemResponse is empty, roomId: $roomId, currentProfileId: $currentProfileId');
    }
    final chatLobbyItem = chatLobbyItemResponse.first;

    return ChatLobbyItemState(
      otherProfile: Profile.fromMap(chatLobbyItem['profiles'].first),
      newestMessage: chatLobbyItem['messages'].isNotEmpty
          ? Message.fromMap(chatLobbyItem['messages'].first)
          : null,
    );
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
Stream<int> unReadMessagesStream(UnReadMessagesStreamRef ref,
    [String? roomId]) {
  final currentProfileId = ref.watch(currentUserIdProvider)!;
  final chatLobbyRepository = ref.watch(chatLobbyRepositoryProvider);
  return chatLobbyRepository.watchUnReadMessages(
      profileId: currentProfileId, roomId: roomId);
}
