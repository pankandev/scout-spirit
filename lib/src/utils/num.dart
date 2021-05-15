import 'dart:math' as math;

double roundToDigits(double num, int digits) {
  double digitsFactor = math.pow(10.0, digits) as double;
  return (num * digitsFactor).roundToDouble() / digitsFactor;
}