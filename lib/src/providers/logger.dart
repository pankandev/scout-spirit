import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class LoggerService {
  static LoggerService _instance = LoggerService._internal();

  LoggerService._internal();

  factory LoggerService() {
    return _instance;
  }

  Future<void> log(String tag, String message, {List<dynamic>? params}) async {
    if (kDebugMode) {
      String full = "[$tag] $message";
      print(full);
      await Sentry.captureMessage(full, params: params?.map((e) => e.toString()).toList());
    }
  }

  Future<void> warn(String tag, String message) async {
    if (kDebugMode) {
      print("[$tag:WARN] " + message);
    }
    await Sentry.captureMessage(message);
  }

  Future<void> error(Object error, StackTrace stackTrace) async {
    await Sentry.captureException(error, stackTrace: stackTrace);
  }
}
