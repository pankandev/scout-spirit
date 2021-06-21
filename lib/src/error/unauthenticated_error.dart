import 'package:scout_spirit/src/error/app_error.dart';

class UnauthenticatedError extends AppError {
  UnauthenticatedError({String message = 'Trying to access resource while unauthenticated'}): super(message: message);
}