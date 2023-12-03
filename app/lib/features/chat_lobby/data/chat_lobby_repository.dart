import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/data/current_profile_provider.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat_lobby/domain/chat_lobby_item_state.dart';
import 'package:chat_app/features/chat_lobby/domain/room.dart';
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

  Future<List<Room>> getAllRooms(String currentUserId) async {
    final roomsList = await supabase
        .from('rooms')
        .select<List<Map<String, dynamic>>>('id, chat_users!inner()')
        .eq('chat_users.profile_id', currentUserId);

    return roomsList.map((room) => Room.fromMap(room)).toList();
  }

  // * Room Detail for each room

  Future<ChatLobbyItemState> getChatLobbyItemState(
    String roomId,
    String currentProfileId,
  ) async {
    final chatLobbyItemResponse = await supabase
        .from('rooms')
        .select<Map<String, dynamic>>('''
          messages (id, profile_id, content, translation, type, created_at),
          profiles!inner (id, username, avatar_url, language)
        ''')
        .eq('id', roomId)
        .neq('profiles.id', currentProfileId)
        .order('created_at', foreignTable: 'messages', ascending: false)
        .limit(1, foreignTable: 'messages')
        .single();

    return ChatLobbyItemState(
      otherProfile: Profile.fromMap(chatLobbyItemResponse['profiles'].first),
      newestMessage: chatLobbyItemResponse['messages'].isNotEmpty
          ? Message.fromMap(chatLobbyItemResponse['messages'].first)
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
FutureOr<List<Room>> getAllRooms(GetAllRoomsRef ref) {
  final currentUserId = ref.watch(authRepositoryProvider).currentUserId!;
  final chatLobbyRepository = ref.watch(chatLobbyRepositoryProvider);
  return chatLobbyRepository.getAllRooms(currentUserId);
}

@riverpod
Stream<int> unReadMessagesStream(UnReadMessagesStreamRef ref,
    [String? roomId]) {
  final currentProfileId = ref.watch(currentProfileProvider).id!;
  final chatLobbyRepository = ref.watch(chatLobbyRepositoryProvider);
  return chatLobbyRepository.watchUnReadMessages(
      profileId: currentProfileId, roomId: roomId);
}
