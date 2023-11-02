// page starts at 0
// defaultRange -> items per request

({int from, int to}) getPagination(
    {required int page, required int defaultRange}) {
  final from = page * defaultRange;
  final to = from + defaultRange - 1;

  return (from: from, to: to);
}
