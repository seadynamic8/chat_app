import 'package:flutter/foundation.dart';

class PaginationState<T> {
  PaginationState({
    this.isLastPage = false,
    required this.nextPage,
    required this.items,
  });

  final bool isLastPage;
  final int nextPage;
  final List<T> items;

  @override
  String toString() =>
      'PaginationState(isLastPage: $isLastPage, nextPage: $nextPage, items: $items)';

  @override
  bool operator ==(covariant PaginationState<T> other) {
    if (identical(this, other)) return true;

    return other.isLastPage == isLastPage &&
        other.nextPage == nextPage &&
        listEquals(other.items, items);
  }

  @override
  int get hashCode => isLastPage.hashCode ^ nextPage.hashCode ^ items.hashCode;

  PaginationState<T> copyWith({
    bool? isLastPage,
    int? nextPage,
    List<T>? items,
  }) {
    return PaginationState<T>(
      isLastPage: isLastPage ?? this.isLastPage,
      nextPage: nextPage ?? this.nextPage,
      items: items ?? this.items,
    );
  }
}
