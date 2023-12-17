import 'package:chat_app/i18n/localizations.dart';

enum BlockStatus { no, current, other, both }

class BlockState {
  final BlockStatus status;

  BlockState({required this.status});

  static BlockState fromMap(
    List<Map<String, dynamic>> blocked, {
    required String currentProfileId,
  }) {
    final status = switch (blocked.length) {
      0 => BlockStatus.no,
      2 => BlockStatus.both,
      1 => blocked.first['blocker_id'] == currentProfileId
          ? BlockStatus.current
          : BlockStatus.other,
      _ => throw Exception('BlockState invalid: more than 2 blocked'),
    };
    return BlockState(status: status);
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
