import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat/application/translation_service.dart';
import 'package:chat_app/features/video_chat/data/video_chat_repository.dart';
import 'package:chat_app/features/video_chat/domain/video_chat_message.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_chat_controller.g.dart';

@riverpod
class VideoChatController extends _$VideoChatController {
  @override
  FutureOr<List<VideoChatMessage>> build() async {
    final videoChatRepository = ref.watch(videoChatRepositoryProvider);

    await videoChatRepository.subscribe(_addVideoChatMessage);

    ref.onDispose(() {
      videoChatRepository.unsubscribe((videoChatMessage) {
        logger.i('UnSubscribe to video chat messages.');
      });
    });

    return [];
  }

  Future<void> sendVideoChatMessage(String message) async {
    await ref.watch(videoChatRepositoryProvider).send(message: message);
  }

  Future<void> _addVideoChatMessage(VideoChatMessage videoChatMessage) async {
    final oldState = await future;
    state = AsyncData([...oldState, videoChatMessage]);

    final currentUserId = ref.read(authRepositoryProvider).currentUserId;
    if (videoChatMessage.senderId != currentUserId) {
      _updateNewMessageTranslation(videoChatMessage);
    }
  }

  void _updateNewMessageTranslation(VideoChatMessage message) async {
    // TODO: Pass otherProfile locale here to use for translation
    final translatedText = await ref
        .read(translationServiceProvider)
        .getTranslation(
            null, message.content); // TODO: Replace null with locale

    if (translatedText == null) return;

    // Update the message with translation
    final oldState = await future;
    final newList = [...oldState];

    // Instead of just using last message, search by id to make sure to find
    // correct message to add translation.
    final messageIndex = newList.indexWhere((m) => m.id == message.id);
    newList[messageIndex] =
        newList[messageIndex].copyWith(translation: translatedText);

    state = AsyncData(newList);
  }
}
