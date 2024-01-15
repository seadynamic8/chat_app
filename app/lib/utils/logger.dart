// import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

// class MyPrinter extends PrettyPrinter {
//   final String className;

//   MyPrinter({this.className = ''})
//       : super(
//           methodCount: 1,
//           errorMethodCount: 8,
//           lineLength: 60,
//           noBoxingByDefault: true,
//           excludeBox: {
//             Level.error: false,
//           },
//         );

//   @override
//   List<String> log(LogEvent event) {
//     if (event.level == Level.error) return super.log(event);

//     final color = PrettyPrinter.defaultLevelColors[event.level];
//     final emoji = PrettyPrinter.defaultLevelEmojis[event.level];
//     final errorString = '$emoji $className - ${event.message}';
//     return [color == null ? errorString : color(errorString)];
//   }
// }

// Custom logger that will display class name with messages
// Logger getLogger(String className) {
//   return Logger(printer: MyPrinter(className: className));
// }

class MyCustomTalkerLog extends TalkerLog {
  MyCustomTalkerLog(
    this.msg, {
    this.className,
    super.logLevel,
    super.exception,
    super.error,
    super.stackTrace,
    super.title,
    super.time,
    super.pen,
  }) : super(msg);

  final String? className;
  final String msg;

  @override
  String get message => '${className != null ? "$className - " : ""} $msg';
}

class MyLogger {
  MyLogger({required this.logger});

  final Talker logger;

  static int grey(double level) => 232 + (level.clamp(0.0, 1.0) * 23).round();

  void t(dynamic msg, {Object? error, StackTrace? stackTrace}) {
    logger.log(
      msg,
      exception: error,
      stackTrace: stackTrace,
      logLevel: LogLevel.verbose,
      pen: AnsiPen()..xterm(grey(0.5)),
    );
  }

  void w(dynamic msg, {Object? error, StackTrace? stackTrace}) {
    logger.log(
      msg,
      exception: error,
      stackTrace: stackTrace,
      logLevel: LogLevel.warning,
      pen: AnsiPen()..xterm(208),
    );
  }

  void d(dynamic msg, {Object? error, StackTrace? stackTrace}) {
    logger.debug(msg, error, stackTrace);
  }

  void i(dynamic msg, {Object? error, StackTrace? stackTrace}) {
    logger.log(
      msg,
      exception: error,
      stackTrace: stackTrace,
      logLevel: LogLevel.info,
      pen: AnsiPen()..xterm(12),
    );
  }

  void e(dynamic msg, {Object? error, StackTrace? stackTrace}) {
    logger.log(
      msg,
      exception: error,
      stackTrace: stackTrace,
      logLevel: LogLevel.error,
      pen: AnsiPen()..xterm(196),
    );
  }

  void f(dynamic msg, {Object? error, StackTrace? stackTrace}) {
    logger.log(
      msg,
      exception: error,
      stackTrace: stackTrace,
      logLevel: LogLevel.critical,
      pen: AnsiPen()..xterm(199),
    );
  }

  void good(dynamic msg, {Object? error, StackTrace? stackTrace}) {
    logger.good(msg, error, stackTrace);
  }

  void handle(Object error, {StackTrace? stackTrace, dynamic message}) {
    logger.handle(error, stackTrace, message);
  }

  void logClass(
    dynamic msg, {
    required String className,
    Object? error,
    StackTrace? stackTrace,
  }) {
    logger.logTyped(MyCustomTalkerLog(msg, className: className));
  }
}

// log error with sentry log
Future<void> logError(String message, Object error, StackTrace st) async {
  logger.e(message, error: error, stackTrace: st);
  // Sentry can await, but is too slow for request, so just fire and forget
  Sentry.captureException(error, stackTrace: st);
}

// log error with sentry log message
Future<void> logErrorMessage(String message) async {
  logger.e(message, stackTrace: StackTrace.current);
  // Sentry can await, but is too slow for request, so just fire and forget
  Sentry.captureMessage(message, level: SentryLevel.error);
}

final talker = TalkerFlutter.init();

final logger = MyLogger(logger: talker);

// final logger = Logger(
//   printer: PrettyPrinter(
//     methodCount: 0,
//     errorMethodCount: 8,
//     lineLength: 60,
//     noBoxingByDefault: true,
//     excludeBox: {
//       Level.error: false,
//     },
//   ),
// );