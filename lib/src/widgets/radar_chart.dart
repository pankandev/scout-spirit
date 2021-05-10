import 'dart:math' as math;

import 'package:flutter/material.dart';

class RadarItem {
  final double value;
  final String label;

  RadarItem({required this.value, required this.label});
}

class RadarChart extends StatelessWidget {
  final Iterable<RadarItem> items;
  final Color fillColor;
  final Color backColor;
  final Color borderColor;
  final BoxConstraints? constraints;

  int get nValues {
    return items.length;
  }

  Iterable<double> get values {
    return items.map((e) => e.value);
  }

  const RadarChart(
      {Key? key,
      required this.items,
      this.fillColor = Colors.white54,
      this.backColor = Colors.white10,
      this.borderColor = Colors.white54,
      this.constraints})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      decoration: ShapeDecoration(
        color: backColor,
        shape: RadarShape(
            values: List.filled(nValues, 1.0),
            borderColor: borderColor,
            borderWidth: 2),
      ),
      child: Container(
        decoration: ShapeDecoration(
            shape: RadarShape(values: values), color: fillColor),
      ),
    );
  }
}

class RadarShape extends ShapeBorder {
  final double angleOffset;
  final Color? borderColor;
  final double borderWidth;
  final Iterable<double> values;
  final Iterable<String>? labels;

  RadarShape(
      {required this.values,
      this.labels,
      this.angleOffset = 0.0,
      this.borderColor,
      this.borderWidth = 1.0});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    double maxRadius = math.min(rect.height, rect.width);

    double centerX = rect.left + rect.width / 2;
    double centerY = rect.top + rect.height / 2;

    double maxValue = values.fold(
        0.0,
        (double previousValue, double element) =>
            math.max(previousValue, element));

    Path path = Path();
    int idx = 0;
    for (double value in values) {
      double fullAngle = 2 * math.pi;
      double angle = (idx / values.length) * fullAngle + angleOffset;

      double x = centerX + maxRadius * (math.cos(angle) / 2) * value / maxValue;
      double y = centerY + maxRadius * (math.sin(angle) / 2) * value / maxValue;
      if (idx == 0) {
        path.moveTo(x, y);
      }
      path.lineTo(x, y);
      idx++;
    }
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (this.borderColor == null) {
      return;
    }
    Paint paint = Paint();
    paint.color = this.borderColor!;
    paint.strokeWidth = this.borderWidth;
    paint.style = PaintingStyle.stroke;

    canvas.drawPath(getOuterPath(rect, textDirection: textDirection), paint);
  }

  @override
  ShapeBorder scale(double t) {
    return this;
  }
}
