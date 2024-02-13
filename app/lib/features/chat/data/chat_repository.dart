import 'dart:async';

import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/chat_lobby/domain/room.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:chat_app/utils/pagination.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_repository.g.dart';

enum VideoStatus { started, cancelled, rejected, ended }

class ChatRepository {
  ChatRepository({required this.supabase});

  final SupabaseClient supabase;

  // * Get message

  Future<Message> getMessage(String messageId) async {
    try {
      final message = await supabase
          .from('messages')
          .select('id, type, profile_id, content, translation, created_at')
          .eq('id', messageId)
          .single();
      return Message.fromMap(message);
    } catch (error, st) {
      logger.error('getMessage()', error, st);
      rethrow;
    }
  }

  // * New message being sent, saved to DB

  Future<void> saveMessage(String otherProfileId, Message message) async {
    try {
      final messageResponse = await supabase
          .from('messages')
          .insert(message.toMap())
          .select()
          .single();

      // Save message as "not read" for other user
      await supabase.from('messages_users').insert({
        'message_id': messageResponse['id'],
        'profile_id': otherProfileId,
        'room_id': message.roomId,
        'read':
            false, // Though this is default, setting it to be safe and clear
      });
    } catch (error, st) {
      logger.error('saveMessage()', error, st);
      throw Exception('Unable to create message'.i18n);
    }
  }

  // * Get message listings

  Future<List<Message>> getAllMessagesForRoom(
      String roomId, int page, int range) async {
    try {
      final (from: from, to: to) =
          getPagination(page: page, defaultRange: range);

      final messages = await supabase
          .from('messages')
          .select('''
          id,
          type,
          content,
          profile_id,
          translation,
          created_at,
          reply_message:parent_message_id (id, type, profile_id, content, translation, created_at)
        ''')
          .eq('room_id', roomId)
          .order('created_at', ascending: false)
          .range(from, to);

      return messages.map((message) => Message.fromMap(message)).toList();
    } catch (error, st) {
      logger.error('getAllMessagesForRoom()', error, st);
      throw Exception(
          'Something went wrong with getting list of previous messages'.i18n);
    }
  }

  // * Status Message

  Future<void> updateStatus({
    required String statusType,
    required String statusName,
    required String roomId,
    required String profileId,
  }) async {
    try {
      await supabase.from('messages').insert({
        'type': statusType,
        'content': statusName,
        'room_id': roomId,
        'profile_id': profileId
      });
    } catch (error, st) {
      logger.error('updateStatus()', error, st);
      rethrow;
    }
  }

  // * Watch for any new messages

  Stream<Message> watchNewMessageForRoom(String roomId) async* {
    final streamController = StreamController<Message>();

    supabase
        .channel('public:messages:room=eq.$roomId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'room_id',
            value: roomId,
          ),
          callback: (PostgresChangePayload payload) async {
            try {
              final messageMap = payload.newRecord;
              var message = Message.fromMap(messageMap);

              if (messageMap['parent_message_id'] != null) {
                final replyMessage =
                    await getMessage(messageMap['parent_message_id'] as String);
                message = message.copyWith(replyMessage: replyMessage);
              }
              streamController.add(message);
            } catch (error, st) {
              logger.error('watchNewMessageForRoom()', error, st);
            }
          },
        )
        .subscribe();

    yield* streamController.stream;
  }

  // * Mark all messages as read

  Future<void> markAllMessagesAsReadForRoom(
      String roomId, String profileId) async {
    try {
      await supabase.from('messages_users').update({
        'read': true,
        'read_at': DateTime.now().toUtc().toIso8601String(),
      }).match({'room_id': roomId, 'profile_id': profileId});

      await supabase.rpc('delete_read_messages_except_last',
          params: {'profile_id': profileId, 'room_id': roomId});
    } catch (error, st) {
      logger.error('markAllMessagesAsReadForRoom()', error, st);
      rethrow;
    }
  }

  // * Mark new messages as read

  Future<void> markMessageAsRead(String messageId) async {
    try {
      await supabase.from('messages_users').update({
        'read': true,
        'read_at': DateTime.now().toIso8601String(),
      }).eq('message_id', messageId);
    } catch (error, st) {
      logger.error('markMessageAsRead()', error, st);
      rethrow;
    }
  }

  // * Save translation for new message

  void saveTranslationForMessage(String messageId, String translation) async {
    await supabase
        .from('messages')
        .update({'translation': translation}).eq('id', messageId);
    try {} catch (error, st) {
      logger.error('saveTranslationForMessage()', error, st);
      rethrow;
    }
  }

  // * Block user

  Future<void> blockUser(
    String blockerProfileId,
    String blockedProfileId,
  ) async {
    try {
      await supabase.from('blocked_users').insert({
        'blocker_id': blockerProfileId,
        'blocked_id': blockedProfileId,
      });
    } catch (error, st) {
      logger.error('blockUser()', error, st);
      rethrow;
    }
  }

  Future<void> unBlockUser(
    String blockerProfileId,
    String blockedProfileId,
  ) async {
    try {
      await supabase.from('blocked_users').delete().match({
        'blocker_id': blockerProfileId,
        'blocked_id': blockedProfileId,
      });
    } catch (error, st) {
      logger.error('unBlockUser()', error, st);
      rethrow;
    }
  }

  // * Join / Request Chat Room Status

  Future<bool> getJoinStatus(String roomId, String profileId) async {
    try {
      final chatUser = await supabase
          .from('chat_users')
          .select('joined')
          .eq('room_id', roomId)
          .eq('profile_id', profileId)
          .single();

      return chatUser['joined'] as bool;
    } catch (error, st) {
      logger.error('getJoinStatus()', error, st);
      rethrow;
    }
  }

  Stream<Map<String, dynamic>> watchChatUserInsert(String profileId) {
    final streamController = StreamController<Map<String, dynamic>>();

    supabase
        .channel('public:chat_users:insert:profile_id=eq.$profileId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_users',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'profile_id',
            value: profileId,
          ),
          callback: (PostgresChangePayload payload) async {
            final chatUser = payload.newRecord;
            streamController.add(chatUser);
          },
        )
        .subscribe();

    return streamController.stream;
  }

  Stream<Map<String, dynamic>> watchChatUserUpdate(String profileId) {
    final streamController = StreamController<Map<String, dynamic>>();

    supabase
        .channel('public:chat_users:update:profile_id=eq.$profileId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'chat_users',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'profile_id',
            value: profileId,
          ),
          callback: (PostgresChangePayload payload) async {
            final chatUser = payload.newRecord;
            streamController.add(chatUser);
          },
        )
        .subscribe();

    return streamController.stream;
  }

  Future<void> markRoomAsJoined(String roomId, String currentUserId) async {
    try {
      await supabase.from('chat_users').update({'joined': true}).match(
          {'room_id': roomId, 'profile_id': currentUserId});
    } catch (error, st) {
      logger.error('markRoomAsJoined()', error, st);
      rethrow;
    }
  }
}

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  return ChatRepository(supabase: supabase);
}

@riverpod
Stream<Message> newMessagesStream(NewMessagesStreamRef ref, String roomId) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.watchNewMessageForRoom(roomId);
}

@riverpod
Stream<Map<String, dynamic>> chatUserInsert(ChatUserInsertRef ref) {
  final currentUserId = ref.watch(currentUserIdProvider)!;
  final chatLobbyRepository = ref.watch(chatRepositoryProvider);
  return chatLobbyRepository.watchChatUserInsert(currentUserId);
}

@riverpod
Stream<Map<String, dynamic>> chatUserUpdate(ChatUserUpdateRef ref) {
  final currentUserId = ref.watch(currentUserIdProvider)!;
  final chatLobbyRepository = ref.watch(chatRepositoryProvider);
  return chatLobbyRepository.watchChatUserUpdate(currentUserId);
}

@riverpod
Stream<bool> onJoinForRoom(OnJoinForRoomRef ref, String roomId) {
  final streamController = StreamController<bool>();
  ref.watch(chatUserUpdateProvider).whenData((chatUser) {
    if (chatUser['joined'] == true && chatUser['room_id'] == roomId) {
      streamController.add(true);
    }
  });
  return streamController.stream;
}

@riverpod
Stream<Room> newRequestedRoom(NewRequestedRoomRef ref) {
  final streamController = StreamController<Room>();
  ref.watch(chatUserInsertProvider).whenData((chatUser) {
    if (chatUser['joined'] == false) {
      streamController.add(Room(id: chatUser['room_id']));
    }
  });
  return streamController.stream;
}

@riverpod
Stream<Room> joinedRoom(JoinedRoomRef ref) {
  final streamController = StreamController<Room>();
  ref.watch(chatUserInsertProvider).whenData((chatUser) {
    if (chatUser['joined'] == true) {
      streamController.add(Room(id: chatUser['room_id']));
    }
  });
  ref.watch(chatUserUpdateProvider).whenData((chatUser) {
    if (chatUser['joined'] == true) {
      streamController.add(Room(id: chatUser['room_id']));
    }
  });
  return streamController.stream;
}
