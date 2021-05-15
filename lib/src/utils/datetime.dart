import 'dart:core';

String padZero(int num, int nZeros) {
  return num.toString().padLeft(nZeros, '0');
}

String dateToString(DateTime dateTime) {
  return "${padZero(dateTime.day, 2)}-${padZero(dateTime.month, 2)}-${padZero(dateTime.year, 2)}";
}

String dateTimeToString(DateTime dateTime) {
  return "${padZero(dateTime.day, 2)}/${padZero(dateTime.month, 2)}/${padZero(dateTime.year, 2)} ${padZero(dateTime.hour, 2)}:${padZero(dateTime.minute, 2)}:${padZero(dateTime.second, 2)}";
}
