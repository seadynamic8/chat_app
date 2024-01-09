extension NewDayExtension on DateTime {
  // current DateTime is the "newer" date
  bool isNewDayAfter(DateTime? older) {
    if (older == null) return false;

    // Localize times before checking
    final local = toLocal();
    final localOlder = older.toLocal();

    if (localOlder.year < local.year) return true;
    // -> Year has to be equal
    if (localOlder.month < local.month) return true;
    // -> Month has to be equal
    if (localOlder.day < local.day) return true;
    // -> Same day then
    return false;
  }
}
