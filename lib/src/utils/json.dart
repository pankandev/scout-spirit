import 'package:scout_spirit/src/error/app_error.dart';

class JsonUtils {
  static List<T> toList<T>(dynamic value, {bool emptyIfNull = false}) {
    if (value == null) return emptyIfNull ? [] : null;
    return List<T>.from(value.map((x) => to<T>(x)));
  }

  static T to<T>(dynamic value, {T defaultIfError, T valueIfNull, bool throwIfError = true}) {
    if (value == null) return null;
    T transformed;
    try {
      if (T == int) return _toInt(value) as T;
      if (T == bool) return _toBool(value) as T;
      if (T == double) return _toDouble(value) as T;
      transformed = value as T;
      return transformed;
    } catch (e) {
      if (throwIfError) throw e;
      transformed = defaultIfError;
    }
    if (transformed == null) {
      transformed = valueIfNull;
    }
    return transformed;
  }

  static int boolToInt(bool value, {int valueIfNull}) {
    if (value == null)
      return valueIfNull;
    return value ? 1 : 0;
  }

  static bool _toBool(dynamic value) {
    if (value == null || value == "") return null;

    switch (value.toString().toLowerCase()) {
      case "0":
        return false;
      case "1":
        return true;
      case "true":
        return true;
      case "false":
        return false;
    }
    throw new AppError(message: 'Can\'t convert value $value to boolean');
  }

  static double _toDouble(dynamic value) {
    if (value == null || value == "") return null;
    if (value is String) {
      return double.parse(value.replaceAll(',', '.'));
    }
    else if (value is int) {
      return value.toDouble();
    }
    else if (value is double) {
      return value;
    }
    throw new AppError(message: 'Can\'t convert value $value to double');
  }

  static int _toInt(dynamic value) {
    if (value == null || value == "") return null;

    if (value is String) {
      return int.parse(value);
    } else if (value is double) {
      return value.floor();
    }
    else if (value is int) return value;
    throw new AppError(message: 'Can\'t convert value $value to int');
  }
}
