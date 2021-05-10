import 'package:flutter/material.dart';

class DialogClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    return Path()
      ..lineTo(size.width * 0.63, size.height * 0.03)
      ..cubicTo(size.width * 0.73, size.height * 0.01, size.width * 0.86,
          size.height * 0.01, size.width * 0.93, size.height * 0.03)
      ..cubicTo(size.width * 0.96, size.height * 0.04, size.width,
          size.height * 0.08, size.width, size.height * 0.19)
      ..cubicTo(size.width, size.height * 0.51, size.width, size.height * 0.76,
          size.width * 0.94, size.height * 0.88)
      ..cubicTo(size.width * 0.83, size.height * 1.08, size.width * 0.6,
          size.height * 0.98, size.width * 0.51, size.height * 0.98)
      ..cubicTo(size.width * 0.41, size.height * 0.98, size.width * 0.1,
          size.height * 1.08, size.width * 0.06, size.height * 0.87)
      ..cubicTo(size.width * 0.05, size.height * 0.84, size.width * 0.02,
          size.height * 0.74, 0, size.height * 0.6)
      ..cubicTo(-0.01, size.height * 0.47, size.width * 0.01,
          size.height * 0.28, size.width * 0.03, size.height * 0.12)
      ..cubicTo(size.width * 0.05, -0.04, size.width / 5, size.height * 0.01,
          size.width * 0.28, size.height * 0.03)
      ..cubicTo(size.width * 0.43, size.height * 0.08, size.width * 0.52,
          size.height * 0.06, size.width * 0.63, size.height * 0.03)
      ..cubicTo(size.width * 0.63, size.height * 0.03, size.width * 0.63,
          size.height * 0.03, size.width * 0.63, size.height * 0.03)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
