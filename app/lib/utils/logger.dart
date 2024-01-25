import 'package:chat_app/common/remote_error_repository.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logger.g.dart';

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

class LoggerRepository {
  LoggerRepository({required this.ref});

  final Ref ref;
  final Talker talker = TalkerFlutter.init();

  static int grey(double level) => 232 + (level.clamp(0.0, 1.0) * 23).round();

  void t(dynamic msg, {Object? error, StackTrace? stackTrace}) {
    _logCustom(
      msg,
      exception: error,
      stackTrace: stackTrace,
      logLevel: LogLevel.verbose,
      pen: AnsiPen()..xterm(grey(0.5)),
    );
  }

  void w(dynamic msg, {Object? error, StackTrace? stackTrace}) {
    _logCustom(
      msg,
      exception: error,
      stackTrace: stackTrace,
      logLevel: LogLevel.warning,
      pen: AnsiPen()..xterm(208),
    );
  }

  void d(dynamic msg, {Object? error, StackTrace? stackTrace}) {
    talker.debug(msg, error, stackTrace);
  }

  void i(dynamic msg, {Object? error, StackTrace? stackTrace}) {
    _logCustom(
      msg,
      exception: error,
      stackTrace: stackTrace,
      logLevel: LogLevel.info,
      pen: AnsiPen()..xterm(12),
    );
  }

  void e(dynamic msg, {Object? error, StackTrace? stackTrace}) {
    _logCustom(
      msg,
      exception: error,
      stackTrace: stackTrace,
      logLevel: LogLevel.error,
      pen: AnsiPen()..xterm(196),
    );
  }

  void f(dynamic msg, {Object? error, StackTrace? stackTrace}) {
    _logCustom(
      msg,
      exception: error,
      stackTrace: stackTrace,
      logLevel: LogLevel.critical,
      pen: AnsiPen()..xterm(199),
    );
  }

  void good(dynamic msg, {Object? error, StackTrace? stackTrace}) {
    talker.good(msg, error, stackTrace);
  }

  void handle(Object error, {StackTrace? stackTrace, dynamic message}) {
    talker.handle(error, stackTrace, message);
  }

  void logClass(
    dynamic msg, {
    required String className,
    Object? error,
    StackTrace? stackTrace,
  }) {
    talker.logTyped(MyCustomTalkerLog(msg, className: className));
  }

  void error(String message, Object error, StackTrace st) {
    e(message, error: error, stackTrace: st);
    ref.read(remoteErrorProvider).captureRemoteError(error, stackTrace: st);
  }

  void message(String message) {
    e(message, stackTrace: StackTrace.current);
    ref.read(remoteErrorProvider).captureRemoteErrorMessage(message);
  }

  void _logCustom(
    dynamic msg, {
    required LogLevel logLevel,
    Object? exception,
    StackTrace? stackTrace,
    AnsiPen? pen,
  }) async {
    final currentProfile = await ref.read(currentProfileStreamProvider.future);

    talker.log(
      currentProfile != null ? '[User: ${currentProfile.username}]: $msg' : msg,
      exception: exception,
      stackTrace: stackTrace,
      logLevel: logLevel,
      pen: pen,
    );
  }
}

@riverpod
LoggerRepository loggerRepository(LoggerRepositoryRef ref) {
  return LoggerRepository(ref: ref);
}

final logger = ProviderContainer().read(loggerRepositoryProvider);
