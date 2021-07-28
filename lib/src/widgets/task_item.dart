import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/task.dart';
import 'package:scout_spirit/src/themes/constants.dart';

class TaskItem extends StatelessWidget {
  final SubTask task;
  final Function()? onEdit;
  final Function()? onDelete;
  final Function()? onToggle;
  final bool? value;

  const TaskItem(
      {Key? key,
      required this.task,
      this.onEdit,
      this.onDelete,
      this.onToggle,
      this.value})
      : super(key: key);

  Color get checkColor {
    switch (value) {
      case false:
        return Color.fromRGBO(72, 72, 72, 1);
      case true:
        return Color.fromRGBO(38, 193, 101, 1.0);
      default:
        return Color.fromRGBO(72, 72, 72, 1);
    }
  }

  Color get checkBackColor {
    switch (value) {
      case false:
        return Color.fromRGBO(218, 218, 218, 1);
      case true:
        return Color.fromRGBO(105, 236, 158, 1.0);
      default:
        return Color.fromRGBO(218, 218, 218, 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isOn = value != null && value!;
    return InkWell(
      onTap: onToggle,
      child: Container(
          decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                Shadows.glowColor(isOn ? checkBackColor : Colors.white)
              ],
              borderRadius: BorderRadii.xxlarge,
              color: Color.lerp(
                  isOn ? checkBackColor : Colors.white, Colors.white, 0.7)),
          child: Row(
            children: [
              Padding(
                padding: Paddings.allMedium,
                child: Container(
                  padding: Paddings.allLarge,
                  decoration: BoxDecoration(
                      boxShadow: [if (isOn) Shadows.glowColor(checkBackColor)],
                      shape: BoxShape.circle,
                      color: checkBackColor),
                  child: Icon(
                    Icons.check,
                    color: checkColor,
                    size: IconSizes.medium,
                  ),
                ),
              ),
              HSpacings.medium,
              Expanded(
                child: Text(
                    task.description.isNotEmpty
                        ? task.description
                        : 'Tarea vacía...',
                    style: task.description.isNotEmpty
                        ? TextStyles.buttonLight
                        : TextStyles.buttonLight.copyWith(color: Colors.grey)),
              ),
              Flexible(
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    onEdit != null
                        ? Flexible(
                            child: RawMaterialButton(
                              shape: CircleBorder(
                                  side: BorderSide(
                                      color: Colors.blue,
                                      width: Dimensions.xxsmall)),
                              splashColor: Colors.blue.withOpacity(0.4),
                              padding: Paddings.allLarge,
                              child: Icon(
                                Icons.edit,
                                color: Colors.blue,
                                size: IconSizes.medium,
                              ),
                              onPressed: onEdit,
                            ),
                          )
                        : Container(),
                    onDelete != null
                        ? Flexible(
                            child: RawMaterialButton(
                              shape: CircleBorder(
                                  side: BorderSide(
                                      color: Colors.redAccent,
                                      width: Dimensions.xxsmall)),
                              padding: Paddings.allLarge,
                              splashColor: Colors.redAccent.withOpacity(0.4),
                              child: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                                size: IconSizes.medium,
                              ),
                              onPressed: onDelete,
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
