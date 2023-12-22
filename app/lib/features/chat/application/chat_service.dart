import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/data/current_profile_provider.dart';
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

    if (blockState.status == BlockStatus.no) {
      final currentProfileId = ref.read(currentProfileProvider).id!;

      await ref.read(chatRepositoryProvider).saveMessage(
            roomId,
            otherProfileId,
            Message(content: messageText, profileId: currentProfileId),
          );
    }
    return blockState;
  }
}

@riverpod
ChatService chatService(ChatServiceRef ref) {
  return ChatService(ref: ref);
}
