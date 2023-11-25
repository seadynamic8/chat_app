import 'dart:async';

import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat/domain/room.dart';
import 'package:chat_app/utils/pagination.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_repository.g.dart';

enum VideoStatus { started, cancelled, rejected, ended }

class ChatRepository {
  ChatRepository({required this.supabase});

  final SupabaseClient supabase;

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

  Future<Map<String, Profile>> getProfilesForRoom(String roomId) async {
    final profilesList = await supabase
        .from('profiles')
        .select<List<Map<String, dynamic>>>(
            'id, username, avatar_url, language, rooms!inner()');

    return {
      for (final profile in profilesList)
        profile['id']: Profile.fromMap(profile)
    };
  }

  Future<Map<String, Profile>> getBothProfiles({
    required String currentProfileId,
    required String otherProfileId,
  }) async {
    final profilesList = await supabase
        .from('profiles')
        .select<List<Map<String, dynamic>>>(
            'id, username, avatar_url, language, country')
        .in_('id', [currentProfileId, otherProfileId]);

    return {
      for (final profile in profilesList)
        profile['id']: Profile.fromMap(profile)
    };
  }

  Future<List<Room>> getAllRoomsByUser(String currentUserId) async {
    // p1 is to make sure that the current user is also in the room.
    // p2 is the other user in the room.
    final roomsList = await supabase
        .from('rooms')
        .select<List<Map<String, dynamic>>>('''
          id,
          p1:profiles!inner (),
          p2:profiles!inner (id, username, avatar_url, language),
          messages (id, profile_id, content, translation, type, created_at)
        ''')
        .eq('p1.id', currentUserId)
        .neq('p2.id', currentUserId)
        .order('created_at', foreignTable: 'messages', ascending: false)
        .limit(1, foreignTable: 'messages');

    return roomsList.map((room) => Room.fromMap(room)).toList();
  }

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

        final newRoom = await getLatestRoom(chatUser['room_id'], currentUserId);
        callback(newRoom);
      },
    ).subscribe();
  }

  // This doesn't need to query messages, because the a new room won't have any
  Future<Room> getLatestRoom(String roomId, String currentUserId) async {
    final latestRoomMap =
        await supabase.from('rooms').select<Map<String, dynamic>>('''
        id,
        profiles!inner (id, username, avatar_url)
      ''').eq('id', roomId).neq('profiles.id', currentUserId).single();

    return Room.fromMap(latestRoomMap);
  }

  // * Messages

  Future<void> saveMessage(String roomId, Message message) async {
    await supabase.from('messages').insert({
      'content': message.content,
      'profile_id': message.profileId,
      'room_id': roomId,
    });
  }

  Future<List<Message>> getAllMessagesForRoom(
      String roomId, int page, int range) async {
    final (from: from, to: to) = getPagination(page: page, defaultRange: range);

    final messages = await supabase
        .from('messages')
        .select<List<Map<String, dynamic>>>('''
          id,
          type,
          content,
          profile_id,
          translation
        ''')
        .eq('room_id', roomId)
        .order('created_at', ascending: false)
        .range(from, to);

    return messages.map((message) => Message.fromMap(message)).toList();
  }

  Stream<Message> watchNewMessageForRoom(String roomId) async* {
    final streamController = StreamController<Message>();

    supabase.channel('public:messages:room=eq.$roomId').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: 'INSERT',
        schema: 'public',
        table: 'messages',
        filter: 'room_id=eq.$roomId',
      ),
      (payload, [ref]) {
        streamController.add(Message.fromMap(payload['new']));
      },
    ).subscribe();

    yield* streamController.stream;
  }

  void saveTranslationForMessage(String messageId, String translation) async {
    await supabase
        .from('messages')
        .update({'translation': translation}).eq('id', messageId);
  }

  // * Video Status (Stored as a Chat Message)

  Future<void> updateVideoStatus({
    required VideoStatus status,
    required String roomId,
    required String currentProfileId,
  }) async {
    await supabase.from('messages').insert({
      'type': 'video',
      'content': status.name,
      'room_id': roomId,
      'profile_id': currentProfileId
    });
  }
}

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  return ChatRepository(supabase: supabase);
}

@riverpod
FutureOr<Map<String, Profile>> getProfilesForRoom(
    GetProfilesForRoomRef ref, String roomId) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.getProfilesForRoom(roomId);
}

@riverpod
FutureOr<List<Room>> getAllRooms(GetAllRoomsRef ref) {
  final currentUserId = ref.watch(authRepositoryProvider).currentUserId!;
  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.getAllRoomsByUser(currentUserId);
}

@riverpod
Stream<Message> watchNewMessagesStream(
    WatchNewMessagesStreamRef ref, String roomId) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.watchNewMessageForRoom(roomId);
}
