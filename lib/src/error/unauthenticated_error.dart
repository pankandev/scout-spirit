import 'package:scout_spirit/src/error/app_error.dart';

class UnauthenticatedError extends AppError {
  UnauthenticatedError({String message}): super(message: message);
}