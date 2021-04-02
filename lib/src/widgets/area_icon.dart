import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/utils/development_area.dart';
import 'package:scout_spirit/src/utils/objectives_icons.dart';

class AreaIcon extends StatelessWidget {
  final DevelopmentArea area;
  final Unit unit;
  final double? size;
  final double? opacity;

  const AreaIcon({Key? key, required this.area, required this.unit, this.size, this.opacity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AreaDisplayData display = ObjectivesDisplay.getAreaIconData(unit, area);
    int alpha = (opacity != null ? opacity! * 255 : 255).round();
    return Icon(
      display.icon,
      color: display.color.withAlpha(alpha),
      size: size,
    );
  }
}
