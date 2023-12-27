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
