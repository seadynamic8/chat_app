import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/home/data/channel_repository.dart';
import 'package:chat_app/features/home/data/channel_presence_handlers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'explore_service.g.dart';

class ExploreService {
  ExploreService({required this.ref});

  final Ref ref;

  Future<List<Profile>> getOtherOnlineProfiles(
      {required int limit, DateTime? lastOnlineAt}) async {
    final lobbyChannel = await ref.read(lobbySubscribedChannelProvider.future);
    // First get online user ids from online presences (for most accurate online data)
    // Also, filter this for the cursor (lastOnlineAt) pagination
    final onlineIds =
        lobbyChannel.getOnlineUserIds(limit: limit, lastOnlineAt: lastOnlineAt);
    // Then use the DB to get profiles with the sorting done by DB, because,
    // even if sort first (on enteredAt), no way to easily keep the sort order
    // after the DB query, and later, may sort by things like country, gender, etc...
    return await ref
        .read(authRepositoryProvider)
        .getOtherOnlineProfiles(onlineIds);
  }
}

@riverpod
ExploreService exploreService(ExploreServiceRef ref) {
  return ExploreService(ref: ref);
}
