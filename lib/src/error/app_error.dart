import 'package:http/http.dart';

class AppError extends Error {
  final String message;

  AppError({required this.message});
}

class HttpError extends AppError {
  int statusCode;

  HttpError({required this.statusCode, required Response response}) : super(message: response.body);

  @override
  String toString() {
    return "HttpError(statusCode: $statusCode, message: '$message')";
  }
}
