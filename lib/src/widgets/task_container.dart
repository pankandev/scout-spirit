import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/utils/objectives_icons.dart';
import 'package:scout_spirit/src/widgets/area_icon.dart';
import 'package:scout_spirit/src/widgets/scout_outlined_button.dart';

class TaskContainer extends StatelessWidget {
  final String? label;
  final Unit unit;
  final Task task;
  final void Function()? onTap;
  final double iconSize;

  const TaskContainer({
    Key? key,
    required this.unit,
    required this.task,
    this.label,
    this.iconSize = 180.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AreaDisplayData display =
        ObjectivesDisplay.getAreaIconData(unit, task.personalObjective.area);
    return AspectRatio(
      aspectRatio: 1.918,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: <BoxShadow>[
              BoxShadow(color: Colors.white54, blurRadius: 12.0)
            ]),
        child: GestureDetector(
          onTap: onTap,
          child: Stack(children: [
            Positioned(
              child: Transform.rotate(
                  angle: -math.pi / 5.0,
                  child: AreaIcon(
                    unit: unit,
                    area: task.personalObjective.area,
                    size: iconSize,
                    opacity: 0.47,
                  )),
              right: -iconSize / 3,
              bottom: -iconSize / 3,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    flex: 2,
                    child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              display.name,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: display.color.withOpacity(0.8),
                                  fontFamily: 'ConcertOne'),
                            ),
                            SizedBox(
                              height: 2.0,
                            ),
                            Text(
                              task.personalObjective.rawObjective,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: 'ConcertOne',
                                  color: Color.fromRGBO(139, 139, 139, 1)),
                            ),
                          ],
                        ),
                        if (label != null)
                          ScoutOutlinedButton(
                            onPressed: onTap,
                            icon: Icons.visibility,
                            label: label!,
                            borderWidth: 2.0,
                            padding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 12.0),
                            color: display.color.withOpacity(0.8),
                          )
                      ],
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
