import 'package:http/http.dart';

class AppError extends Error {
  final String message;

  AppError({required this.message});
}

class HttpError extends AppError {
  bool isAuthorized;
  String endpoint;
  int statusCode;

  HttpError(
      {required this.endpoint,
      required this.statusCode,
      required this.isAuthorized,
      required Response response})
      : super(message: response.body);

  @override
  String toString() {
    return "HttpError(endpoint: $endpoint, statusCode: $statusCode, message: '$message', isAuthorized: $isAuthorized)";
  }
}
