import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/block_state.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/domain/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_service.g.dart';

class ChatService {
  ChatService({required this.ref});

  final Ref ref;

  Future<BlockState> sendMessage({
    required String roomId,
    required String otherProfileId,
    required String messageText,
    required bool joined,
  }) async {
    final blockState =
        await ref.read(blockedByChangesProvider(otherProfileId).future);
    if (blockState.status != BlockStatus.no) return blockState;

    final currentProfile = await ref.read(currentProfileStreamProvider.future);
    await _joinRoomIfNotJoined(joined, roomId, currentProfile!.id!);

    await ref.read(chatRepositoryProvider).saveMessage(
          roomId,
          otherProfileId,
          Message(content: messageText, profileId: currentProfile.id),
        );

    if (await _otherProfileJoined(roomId, otherProfileId)) {
      await _createMessageNotification(
          roomId, currentProfile, otherProfileId, messageText);
    }

    return blockState;
  }

  Future<void> _joinRoomIfNotJoined(
      bool joined, String roomId, String currentProfileId) async {
    if (!joined) {
      await ref
          .read(chatRepositoryProvider)
          .markRoomAsJoined(roomId, currentProfileId);
    }
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
