import 'dart:async';

class Debouncer {
  Debouncer({required this.delay});

  final Duration delay;
  Timer? _timer;

  run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
}
