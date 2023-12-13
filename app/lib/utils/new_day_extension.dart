extension NewDayExtension on DateTime {
  // current DateTime is the "newer" date
  bool isNewDayAfter(DateTime? older) {
    if (older == null) return false;

    if (older.year < year) return true;
    // -> Year has to be equal
    if (older.month < month) return true;
    // -> Month has to be equal
    if (older.day < day) return true;
    // -> Same day then
    return false;
  }
}
