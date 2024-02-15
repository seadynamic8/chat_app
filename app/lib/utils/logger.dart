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
  LoggerRepository({required this.ref, required this.talker});

  final Ref ref;
  final Talker talker;

  void t(dynamic msg, {Object? error, StackTrace? stackTrace}) {
    _logCustom(
      msg,
      exception: error,
      stackTrace: stackTrace,
      logLevel: LogLevel.verbose,
    );
  }

  void w(dynamic msg, {Object? error, StackTrace? stackTrace}) {
    _logCustom(
      msg,
      exception: error,
      stackTrace: stackTrace,
      logLevel: LogLevel.warning,
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
    );
  }

  void e(dynamic msg, {Object? error, StackTrace? stackTrace}) {
    _logCustom(
      msg,
      exception: error,
      stackTrace: stackTrace,
      logLevel: LogLevel.error,
    );
  }

  void f(dynamic msg, {Object? error, StackTrace? stackTrace}) {
    _logCustom(
      msg,
      exception: error,
      stackTrace: stackTrace,
      logLevel: LogLevel.critical,
    );
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
  }) async {
    final currentProfile = await ref.read(currentProfileStreamProvider.future);

    talker.log(
      currentProfile != null ? '[User: ${currentProfile.username}]: $msg' : msg,
      exception: exception,
      stackTrace: stackTrace,
      logLevel: logLevel,
    );
  }
}

int grey(double level) => 232 + (level.clamp(0.0, 1.0) * 23).round();

final talker = TalkerFlutter.init(
  settings: TalkerSettings(
    colors: {
      TalkerLogType.verbose: AnsiPen()..xterm(grey(0.5)),
      TalkerLogType.warning: AnsiPen()..xterm(208),
      TalkerLogType.info: AnsiPen()..xterm(12),
      TalkerLogType.error: AnsiPen()..xterm(196),
      TalkerLogType.critical: AnsiPen()..xterm(199),
    },
  ),
);

@riverpod
LoggerRepository loggerRepository(LoggerRepositoryRef ref) {
  return LoggerRepository(ref: ref, talker: talker);
}

final logger = ProviderContainer().read(loggerRepositoryProvider);
