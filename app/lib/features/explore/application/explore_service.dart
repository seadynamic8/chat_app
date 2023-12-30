import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:chat_app/utils/pagination.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'explore_service.g.dart';

class ExploreService {
  ExploreService({required this.ref});

  final Ref ref;

  Future<List<Profile>> getOtherOnlineProfiles(
      List<String> userIds, int page, int range) async {
    if (userIds.isEmpty) return [];
    final otherUserIds = _getOtherUserIdsFromPage(userIds, page, range);
    logger.i('otherUserIds: $otherUserIds');
    return await ref
        .read(authRepositoryProvider)
        .getOtherProfiles(otherUserIds);
  }

  List<String> _getOtherUserIdsFromPage(
      List<String> otherUserIds, int page, int range) {
    var (from: from, to: to) = getPagination(page: page, defaultRange: range);

    final numOfUserIds = otherUserIds.length;
    if (numOfUserIds == 0) return [];

    // Adjust range if num of items is less than range
    to = (to >= numOfUserIds) ? numOfUserIds - 1 : to;

    // getRange doesn't include the end number, so add 1 to 'to'
    return otherUserIds.getRange(from, to + 1).toList();
  }
}

@riverpod
ExploreService exploreService(ExploreServiceRef ref) {
  return ExploreService(ref: ref);
}
