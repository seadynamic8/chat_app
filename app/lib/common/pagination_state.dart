import 'package:flutter/foundation.dart';

class PaginationState<T> {
  PaginationState({
    this.isLastPage = false,
    this.nextPage,
    this.lastOnlineAt,
    required this.items,
  });

  final bool isLastPage;
  final int? nextPage;
  final DateTime?
      lastOnlineAt; // Used for cursor-based pagination (unique sequential value)
  final List<T> items;

  @override
  String toString() =>
      'PaginationState(isLastPage: $isLastPage, nextPage: $nextPage, lastOnlineAt: $lastOnlineAt, items: $items)';

  @override
  bool operator ==(covariant PaginationState<T> other) {
    if (identical(this, other)) return true;

    return other.isLastPage == isLastPage &&
        other.nextPage == nextPage &&
        other.lastOnlineAt == lastOnlineAt &&
        listEquals(other.items, items);
  }

  @override
  int get hashCode =>
      isLastPage.hashCode ^
      nextPage.hashCode ^
      lastOnlineAt.hashCode ^
      items.hashCode;

  PaginationState<T> copyWith({
    bool? isLastPage,
    int? nextPage,
    DateTime? lastOnlineAt,
    List<T>? items,
  }) {
    return PaginationState<T>(
      isLastPage: isLastPage ?? this.isLastPage,
      nextPage: nextPage ?? this.nextPage,
      lastOnlineAt: lastOnlineAt ?? this.lastOnlineAt,
      items: items ?? this.items,
    );
  }
}
