import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/home/application/current_user_id_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'joined_room_notifier.g.dart';

@riverpod
class JoinedRoomNotifier extends _$JoinedRoomNotifier {
  @override
  FutureOr<bool> build(String roomId) async {
    final currentUserId = ref.watch(currentUserIdProvider);

    final joined = await ref
        .read(chatRepositoryProvider)
        .getJoinStatus(roomId, currentUserId!);

    if (joined == false) {
      ref.listen<AsyncValue<bool>>(onJoinForRoomProvider(roomId), (_, state) {
        state.whenData((joined) => _updateJoinStatus(joined));
      });
    }
    return joined;
  }

  void _updateJoinStatus(bool joined) async {
    state = AsyncData(joined);
  }
}
