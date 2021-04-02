import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/widgets/area_icon.dart';

class TaskContainer extends StatelessWidget {
  final Unit unit;
  final Task task;
  final void Function()? onTap;
  final double? iconSize;

  const TaskContainer({
    Key? key,
    required this.unit,
    required this.task,
    this.iconSize,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.918,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Card(
          child: InkWell(
            onTap: onTap,
            child: Stack(children: [
              Positioned(
                child: Transform.rotate(
                    angle: -3.14 / 5.0,
                    child: AreaIcon(
                      unit: unit,
                      area: task.personalObjective.area,
                      size: iconSize,
                      opacity: 0.57,
                    )),
                right: iconSize != null ? -iconSize! / 3 : null,
                bottom: iconSize != null ? -iconSize! / 3 : null,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 36.0),
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(task.personalObjective.rawObjective)],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
