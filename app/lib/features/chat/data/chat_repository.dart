import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/domain/room.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_repository.g.dart';

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
            'id, username, avatar_url, rooms!inner()');

    return {
      for (final profile in profilesList)
        profile['id']: Profile.fromMap(profile)
    };
  }

  Future<List<Room>> getAllRoomsByUser(String userId) async {
    final roomsList =
        await supabase.from('rooms').select<List<Map<String, dynamic>>>('''
          id,
          p1:profiles!inner (),
          p2:profiles!inner (id, username, avatar_url)
        ''').eq('p1.id', userId).neq('p2.id', userId);

    return roomsList
        .map((room) => Room.fromMapWithCustomProfile(room))
        .toList();
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
