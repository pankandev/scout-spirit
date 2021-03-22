import 'package:scout_spirit/src/error/app_error.dart';

enum DevelopmentArea {
  Corporality,
  Creativity,
  Character,
  Affectivity,
  Sociability,
  Spirituality
}

DevelopmentArea areaFromName(String value) {
  switch (value.toLowerCase()) {
    case "corporality":
      return DevelopmentArea.Corporality;
    case "creativity":
      return DevelopmentArea.Creativity;
    case "character":
      return DevelopmentArea.Character;
    case "affectivity":
      return DevelopmentArea.Affectivity;
    case "sociability":
      return DevelopmentArea.Sociability;
    case "spirituality":
      return DevelopmentArea.Spirituality;
  }
  throw new AppError(message: "Unknown development area name: $value");
}
