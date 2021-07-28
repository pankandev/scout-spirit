import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:quick_log/quick_log.dart';

class LoggerService {
  static LoggerService _instance = LoggerService._internal();

  LoggerService._internal();

  factory LoggerService() {
    return _instance;
  }

  Future<void> log(String tag, String message, {List<dynamic>? params}) async {
    Logger(tag).debug(message);
    if (kDebugMode) {
      // await Sentry.captureMessage(full, params: params?.map((e) => e.toString()).toList());
    }
  }

  Future<void> warn(String tag, String message) async {
    if (kDebugMode) {
      Logger(tag).warning(message);
    }
    await Sentry.captureMessage(message);
  }

  Future<void> error(Object error, StackTrace stackTrace) async {
    await Sentry.captureException(error, stackTrace: stackTrace);
  }
}
