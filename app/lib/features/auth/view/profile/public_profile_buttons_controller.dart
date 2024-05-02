import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat_lobby/data/chat_lobby_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'public_profile_buttons_controller.g.dart';

@riverpod
class PublicProfileButtonsController extends _$PublicProfileButtonsController {
  @override
  FutureOr<bool> build(String otherProfileId) async {
    final room =
        await ref.watch(findRoomWithUserProvider(otherProfileId).future);

    if (room == null) return false;

    return ref
        .read(chatRepositoryProvider)
        .getJoinStatus(room.id, otherProfileId);
  }
}
