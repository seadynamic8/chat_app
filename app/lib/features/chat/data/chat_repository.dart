import 'dart:async';

import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/utils/pagination.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_repository.g.dart';

enum VideoStatus { started, cancelled, rejected, ended }

class ChatRepository {
  ChatRepository({required this.supabase});

  final SupabaseClient supabase;

  // * Get Profiles for the rooms

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

  // * MESSAGES

  // * New message being sent, saved to DB

  Future<void> saveMessage(
      String roomId, String otherProfileId, Message message) async {
    final messageResponse = await supabase
        .from('messages')
        .insert({
          'content': message.content,
          'profile_id': message.profileId,
          'room_id': roomId,
        })
        .select<Map<String, dynamic>>()
        .single();

    // Save message as "not read" for other user
    await supabase.from('messages_users').insert({
      'message_id': messageResponse['id'],
      'profile_id': otherProfileId,
      'room_id': roomId,
      'read': false, // Though this is default, setting it to be safe and clear
    });
  }

  // * Get message listings

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
          translation,
          created_at
        ''')
        .eq('room_id', roomId)
        .order('created_at', ascending: false)
        .range(from, to);

    return messages.map((message) => Message.fromMap(message)).toList();
  }

  // * Status Message

  Future<void> updateStatus({
    required String statusType,
    required String statusName,
    required String roomId,
    required String profileId,
  }) async {
    await supabase.from('messages').insert({
      'type': statusType,
      'content': statusName,
      'room_id': roomId,
      'profile_id': profileId
    });
  }

  // * Watch for any new messages

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

  // * Mark all messages as read

  Future<void> markAllMessagesAsReadForRoom(
      String roomId, String profileId) async {
    await supabase.from('messages_users').update({
      'read': true,
      'read_at': DateTime.now().toIso8601String(),
    }).match({'room_id': roomId, 'profile_id': profileId});
  }

  // * Mark new messages as read

  Future<void> markMessageAsRead(String messageId) async {
    await supabase.from('messages_users').update({
      'read': true,
      'read_at': DateTime.now().toIso8601String(),
    }).eq('message_id', messageId);
  }

  // * Save translation for new message

  void saveTranslationForMessage(String messageId, String translation) async {
    await supabase
        .from('messages')
        .update({'translation': translation}).eq('id', messageId);
  }

  // * Block user

  Future<void> blockUser(
    String blockerProfileId,
    String blockedProfileId,
  ) async {
    await supabase.from('blocked_users').insert({
      'blocker_id': blockerProfileId,
      'blocked_id': blockedProfileId,
    });
  }

  Future<void> unBlockUser(
    String blockerProfileId,
    String blockedProfileId,
  ) async {
    await supabase.from('blocked_users').delete().match({
      'blocker_id': blockerProfileId,
      'blocked_id': blockedProfileId,
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
    GetProfilesForRoomRef ref, String otherProfileId) {
  final currentProfileId = ref.watch(currentUserIdProvider)!;
  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.getBothProfiles(
      currentProfileId: currentProfileId, otherProfileId: otherProfileId);
}

@riverpod
Stream<Message> newMessagesStream(NewMessagesStreamRef ref, String roomId) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.watchNewMessageForRoom(roomId);
}
