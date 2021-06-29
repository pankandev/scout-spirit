import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class LoggerService {
  static LoggerService _instance = LoggerService._internal();

  LoggerService._internal();

  factory LoggerService() {
    return _instance;
  }

  void log(String tag, String message) {
    if (!kReleaseMode) {
      String full = "[$tag] $message";
      print(full);
      Sentry.captureMessage(full);
    }
  }

  void warn(String tag, String message) {
    if (!kReleaseMode) {
      print("[$tag:WARN] " + message);
    }
    Sentry.captureMessage(message);
  }
}
