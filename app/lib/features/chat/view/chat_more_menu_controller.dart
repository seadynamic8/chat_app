import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/block_state.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_more_menu_controller.g.dart';

enum ChatBlockAction { block, unblock }

@riverpod
class ChatMoreMenuController extends _$ChatMoreMenuController {
  @override
  FutureOr<ChatBlockAction> build(String roomId, String otherProfileId) async {
    final blockState =
        await ref.watch(blockedByChangesProvider(otherProfileId).future);

    return switch (blockState.status) {
      BlockStatus.current || BlockStatus.both => ChatBlockAction.unblock,
      _ => ChatBlockAction.block,
    };
  }

  void toggleBlock() async {
    final oldState = await future;
    switch (oldState) {
      case ChatBlockAction.block:
        blockUser();
      case ChatBlockAction.unblock:
        unBlockUser();
    }
  }

  void blockUser() async {
    state = const AsyncLoading();
    await _blockAndUpdateStatus();
    state = const AsyncData(ChatBlockAction.unblock);
  }

  void unBlockUser() async {
    state = const AsyncLoading();
    await _unBlockAndUpdateStatus();
    state = const AsyncData(ChatBlockAction.block);
  }

  Future<void> _blockAndUpdateStatus() async {
    final currentProfileId = ref.read(currentUserIdProvider)!;
    await ref
        .read(chatRepositoryProvider)
        .blockUser(currentProfileId, otherProfileId);
    await ref.read(chatRepositoryProvider).updateStatus(
          statusType: 'block',
          statusName: ChatBlockAction.block.name,
          roomId: roomId,
          profileId: currentProfileId,
        );
  }

  Future<void> _unBlockAndUpdateStatus() async {
    final currentProfileId = ref.read(currentUserIdProvider)!;
    await ref
        .read(chatRepositoryProvider)
        .unBlockUser(currentProfileId, otherProfileId);
    await ref.read(chatRepositoryProvider).updateStatus(
          statusType: 'block',
          statusName: ChatBlockAction.unblock.name,
          roomId: roomId,
          profileId: currentProfileId,
        );
  }
}
