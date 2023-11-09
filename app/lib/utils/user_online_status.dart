import 'package:chat_app/features/home/domain/online_state.dart';

mixin UserOnlineStatus {
  OnlineStatus getUserOnlineStatus(
    Map<String, OnlineState> presences,
    String profileId,
  ) {
    if (!presences.containsKey(profileId)) return OnlineStatus.offline;
    return presences[profileId]!.status;
  }
}
