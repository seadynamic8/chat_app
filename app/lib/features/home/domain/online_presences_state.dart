import 'package:chat_app/features/home/domain/online_state.dart';

class OnlinePresencesState {
  OnlinePresencesState({required this.presences});

  final Map<String, OnlineState> presences;

  OnlineStatus onlineStatusFor(String profileId) {
    return !presences.containsKey(profileId)
        ? OnlineStatus.offline
        : presences[profileId]!.status;
  }

  @override
  String toString() => 'OnlinePresencesState(presences: $presences)';
}
