import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/block_state.dart';
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
  }) async {
    final blockState =
        await ref.read(blockedByChangesProvider(otherProfileId).future);

    if (blockState.status != BlockStatus.no) return blockState;

    final currentProfileId = ref.read(currentUserIdProvider)!;
    await ref.read(chatRepositoryProvider).saveMessage(
          roomId,
          otherProfileId,
          Message(content: messageText, profileId: currentProfileId),
        );
    await _createMessageNotification(
        roomId, currentProfileId, otherProfileId, messageText);

    return blockState;
  }

  Future<void> _createMessageNotification(
    String roomId,
    String currentProfileId,
    String otherProfileId,
    String messageText,
  ) async {
    final otherProfile =
        await ref.read(profileStreamProvider(otherProfileId).future);

    await ref.read(authRepositoryProvider).createNofitication(
      otherProfile.id!,
      notification: {
        'title': 'New Message: ${otherProfile.username}',
        'body': messageText,
      },
      data: {
        'chatRoomId': roomId,
        'profileId': currentProfileId,
      },
    );
  }
}

@riverpod
ChatService chatService(ChatServiceRef ref) {
  return ChatService(ref: ref);
}
