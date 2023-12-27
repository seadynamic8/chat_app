import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 8,
    lineLength: 60,
    noBoxingByDefault: true,
    excludeBox: {
      Level.error: false,
    },
  ),
);

// * Get custom logger that will display class name with messages
Logger getLogger(String className) {
  return Logger(printer: MyPrinter(className: className));
}

class MyPrinter extends PrettyPrinter {
  final String className;

  MyPrinter({this.className = ''})
      : super(
          methodCount: 1,
          errorMethodCount: 8,
          lineLength: 60,
          noBoxingByDefault: true,
          excludeBox: {
            Level.error: false,
          },
        );

  @override
  List<String> log(LogEvent event) {
    if (event.level == Level.error) return super.log(event);

    final color = PrettyPrinter.defaultLevelColors[event.level];
    final emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    final errorString = '$emoji $className - ${event.message}';
    return [color == null ? errorString : color(errorString)];
  }
}

