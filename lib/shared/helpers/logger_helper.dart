import 'package:flutter/foundation.dart';

class LoggerHelper {
  const LoggerHelper._();

  static void debug(String message) {
    if (kDebugMode) {
      debugPrint('[DEBUG] $message');
    }
  }

  static void info(String message) {
    debugPrint('[INFO] $message');
  }

  static void warning(String message) {
    debugPrint('[WARN] $message');
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    debugPrint('[ERROR] $message');
    if (error != null) {
      debugPrint(error.toString());
    }
    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }
}
