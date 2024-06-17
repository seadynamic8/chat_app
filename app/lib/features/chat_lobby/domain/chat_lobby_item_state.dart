// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat/domain/message.dart';

class ChatLobbyItemState {
  ChatLobbyItemState({this.otherProfile, this.newestMessage});

  final Profile? otherProfile;
  final Message? newestMessage;

  ChatLobbyItemState copyWith({
    Profile? otherProfile,
    Message? newestMessage,
  }) {
    return ChatLobbyItemState(
      otherProfile: otherProfile ?? this.otherProfile,
      newestMessage: newestMessage ?? this.newestMessage,
    );
  }

  @override
  String toString() =>
      'ChatLobbyItemState(otherProfile: $otherProfile, newestMessage: $newestMessage)';

  @override
  bool operator ==(covariant ChatLobbyItemState other) {
    if (identical(this, other)) return true;

    return other.otherProfile == otherProfile &&
        other.newestMessage == newestMessage;
  }

  @override
  int get hashCode => otherProfile.hashCode ^ newestMessage.hashCode;
}
