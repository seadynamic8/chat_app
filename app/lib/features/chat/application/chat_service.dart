import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/block_state.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/data/joined_room_notifier.dart';
import 'package:chat_app/features/chat/data/swiped_message_provider.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:chat_app/features/home/application/current_user_id_provider.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:chat_app/utils/new_day_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_service.g.dart';

class ChatService {
  ChatService({required this.ref});

  final Ref ref;

  Future<void> markAllMessagesAsRead(String roomId) async {
    final currentProfileId = ref.read(currentUserIdProvider)!;
    await ref
        .read(chatRepositoryProvider)
        .markAllMessagesAsReadForRoom(roomId, currentProfileId);
  }

  Future<(List<Message>, bool)> getMessagesForRoom({
    required String roomId,
    required int page,
    required int range,
    required int maxMessages,
    Message? lastMessage,
  }) async {
    final messages = await ref
        .read(chatRepositoryProvider)
        .getAllMessagesForRoom(roomId, page, range);
    final updatedMessages = _addNewDayToMessages(lastMessage, messages);

    final isLastPage = messages.length < maxMessages;
    return (updatedMessages, isLastPage);
  }

  Future<BlockState> sendMessage({
    required String roomId,
    required String otherProfileId,
    required String messageText,
  }) async {
    final blockState =
        await ref.read(blockedByChangesProvider(otherProfileId).future);
    if (blockState.status != BlockStatus.no) return blockState;

    final currentProfile = await ref.read(currentProfileStreamProvider.future);
    if (currentProfile == null) {
      logger.error('currentProfile is null in ChatService.sendMessage()',
          Error(), StackTrace.current);
      return blockState;
    }

    await _joinRoomIfNotJoined(roomId, currentProfile.id!);

    final replyMessage = ref.read(swipedMessageProvider);

    await ref.read(chatRepositoryProvider).saveMessage(
          otherProfileId,
          Message(
            content: messageText,
            profileId: currentProfile.id,
            roomId: roomId,
            replyMessage: replyMessage,
          ),
        );

    if (await _otherProfileJoined(roomId, otherProfileId)) {
      await _createMessageNotification(
          roomId, currentProfile, otherProfileId, messageText);
    }

    return blockState;
  }

  // - Handle 2 situations:
  //  - New build with existing messages (no prev message - null)
  //  - getNextPageOfMessages, it needs the last message from the last page.
  List<Message> _addNewDayToMessages(
      Message? prevMessage, List<Message> messages) {
    List<Message> updatedMessages = [];
    // Can be null, also never should add to updated list since it's used only
    //for checking dates, so not inside loop.
    var prev = prevMessage;

    for (final message in messages) {
      if (prev != null && prev.createdAt!.isNewDayAfter(message.createdAt!)) {
        updatedMessages.add(Message.newDay(prev));
      }
      // Always add the current message
      updatedMessages.add(message);

      // Update prev to current message
      prev = message;
    }
    return updatedMessages;
  }

  Future<void> _joinRoomIfNotJoined(
    String roomId,
    String currentProfileId,
  ) async {
    final joined = await ref
        .read(joinedRoomNotifierProvider(roomId, currentProfileId).future);
    if (joined) return;

    await ref
        .read(chatRepositoryProvider)
        .markRoomAsJoined(roomId, currentProfileId);
  }

  Future<bool> _otherProfileJoined(String roomId, String otherProfileId) async {
    return await ref
        .read(chatRepositoryProvider)
        .getJoinStatus(roomId, otherProfileId);
  }

  Future<void> _createMessageNotification(
    String roomId,
    Profile currentProfile,
    String otherProfileId,
    String messageText,
  ) async {
    await ref.read(authRepositoryProvider).createNofitication(
      otherProfileId,
      notification: {
        'title': 'New Message: ${currentProfile.username}',
        'body': messageText,
      },
      data: {
        'chatRoomId': roomId,
        'profileId': currentProfile.id!,
      },
    );
  }
}

@riverpod
ChatService chatService(ChatServiceRef ref) {
  return ChatService(ref: ref);
}
