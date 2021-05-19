import 'dart:math' as math;

import 'package:flutter/material.dart';

class RadarItem {
  final double value;
  final String label;
  final IconData icon;

  RadarItem({required this.value, required this.label, required this.icon});
}

class RadarChart extends StatelessWidget {
  final Iterable<RadarItem> items;
  final Color fillColor;
  final Color backColor;
  final Color borderColor;
  final BoxConstraints? constraints;
  final double iconSizeFactor;
  final double iconChartPadding;

  final Widget? bottomWidget;

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
      this.bottomWidget,
      this.iconSizeFactor = 0.79,
      this.iconChartPadding = 24,
      this.constraints})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double maxHeight = constraints.maxHeight;
                double maxWidth = constraints.maxWidth;
                double minDimension = math.min(maxHeight, maxWidth);

                double iconSize = minDimension * (1 - iconSizeFactor);
                List<RadarItem> elements = items.toList();
                return Stack(
                  children: <Widget>[
                        Center(
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: constraints.maxWidth *
                                        iconSizeFactor *
                                        iconSizeFactor -
                                    iconChartPadding,
                                maxHeight: constraints.maxHeight *
                                        iconSizeFactor *
                                        iconSizeFactor -
                                    iconChartPadding),
                            // background radar
                            decoration: ShapeDecoration(
                              color: backColor,
                              shape: RadarShape(
                                  values: List.filled(nValues, 1.0),
                                  borderColor: borderColor,
                                  borderWidth: 2),
                            ),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth: maxWidth, maxHeight: maxHeight),
                                  // fill radar
                                  decoration: ShapeDecoration(
                                      shape: RadarShape(values: values),
                                      color: fillColor),
                                )
                              ],
                            ),
                          ),
                        ),
                      ] +
                      elements.asMap().keys.map((idx) {
                        double fullAngle = 2 * math.pi;
                        double angle = (idx / values.length) * fullAngle;

                        double centerX = maxWidth / 2;
                        double centerY = maxHeight / 2;
                        double radius =
                            math.min(maxWidth, maxHeight) / 2 - iconSize / 2;

                        RadarItem e = elements[idx];
                        double x =
                            centerX + math.cos(angle) * radius - iconSize / 2;
                        double y =
                            centerY + math.sin(angle) * radius - iconSize / 2;

                        return Positioned(
                            left: x,
                            bottom: y,
                            width: iconSize,
                            height: iconSize,
                            child: Tooltip(
                              preferBelow: false,
                              message: "${e.label}: ${e.value.round()}",
                              waitDuration: Duration.zero,
                              child: RawMaterialButton(
                                onPressed: () {},
                                fillColor: Colors.white12,
                                elevation: 0.0,
                                focusElevation: 0.0,
                                highlightElevation: 0.0,
                                hoverElevation: 0.0,
                                padding: EdgeInsets.all(6.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(64)),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Icon(
                                    e.icon,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ));
                      }).toList(),
                );
              },
            ),
          ),
          if (bottomWidget != null) bottomWidget!
        ],
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
