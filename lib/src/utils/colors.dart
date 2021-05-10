import 'package:flutter/material.dart';

Color getGreyColor(Color color) {
  int average = ((color.green + color.blue + color.red) / 3).round();
  return new Color.fromRGBO(average, average, average, color.opacity);
}
