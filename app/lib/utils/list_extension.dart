extension ListExtension<T> on List<T> {
  int? indexWhereOrNull(bool Function(T) test) {
    final itemIndex = indexWhere((item) => test(item));
    return itemIndex > -1 ? itemIndex : null;
  }
}
