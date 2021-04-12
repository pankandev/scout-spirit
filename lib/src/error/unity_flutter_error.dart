import 'package:scout_spirit/src/error/app_error.dart';

class UnityFlutterError extends Error {
  final String code;
  final String message;
  final AppError? originalError;

  UnityFlutterError({required this.code, required this.message, this.originalError});
}