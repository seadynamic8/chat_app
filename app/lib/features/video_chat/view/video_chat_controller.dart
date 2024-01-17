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
  FutureOr<List<VideoChatMessage>> build(String otherProfileId) async {
    final videoChatRepository =
        await ref.watch(videoChatRepositoryProvider.future);

    await videoChatRepository.subscribe(_addVideoChatMessage);

    ref.onDispose(() {
      videoChatRepository.unsubscribe((videoChatMessage) {
        logger.i('UnSubscribe to video chat messages.');
      });
    });

    return [];
  }

  Future<void> _addVideoChatMessage(VideoChatMessage videoChatMessage) async {
    final oldState = await future;
    state = AsyncData([videoChatMessage, ...oldState]);

    final currentUserId = ref.read(authRepositoryProvider).currentUserId;
    if (videoChatMessage.senderId != currentUserId) {
      _updateNewMessageTranslation(videoChatMessage);
    }
  }

  void _updateNewMessageTranslation(VideoChatMessage newMessage) async {
    final otherProfile =
        await ref.read(profileStreamProvider(newMessage.senderId).future);
    final translatedText = await ref
        .read(translationServiceProvider)
        .getTranslation(otherProfile.language!, newMessage.content);

    if (translatedText == null) return;

    // Update the message with translation
    final oldState = await future;
    final newMessages = oldState.map((oldMessage) {
      if (oldMessage.id == newMessage.id) {
        return oldMessage.copyWith(translation: translatedText);
      }
      return oldMessage;
    }).toList();
    state = AsyncData(newMessages);
  }
}
