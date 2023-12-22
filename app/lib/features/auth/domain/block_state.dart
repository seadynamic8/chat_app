import 'package:chat_app/i18n/localizations.dart';

enum BlockStatus { no, current, other, both }

class BlockState {
  late final BlockStatus status;

  BlockState({required this.status});

  BlockState.fromStatuses(bool currentBlocked, bool otherBlocked) {
    if (currentBlocked && otherBlocked) {
      status = BlockStatus.both;
    } else if (currentBlocked && !otherBlocked) {
      status = BlockStatus.current;
    } else if (!currentBlocked && otherBlocked) {
      status = BlockStatus.other;
    } else {
      status = BlockStatus.no;
    }
  }

  String? get message {
    return switch (status) {
      BlockStatus.current => 'You have blocked the other user'.i18n,
      BlockStatus.other => 'The other user has blocked you'.i18n,
      BlockStatus.both =>
        'Both you and the other user has blocked each other'.i18n,
      _ => null,
    };
  }

  @override
  String toString() => 'BlockState(status: ${status.name})';
}
