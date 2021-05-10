import 'package:flutter/material.dart';

class ScoutIconButton extends StatelessWidget {
  final String? label;
  final IconData icon;
  final Color color;
  final double labelSize;
  final double iconSize;
  final Function()? onPressed;

  const ScoutIconButton(
      {Key? key,
      required this.onPressed,
      required this.icon,
      this.label,
      this.color = Colors.white,
      this.labelSize = 12.0,
      this.iconSize = 46.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.account_circle_outlined,
                size: iconSize,
                color: color,
              ),
              if (label != null)
                SizedBox(
                  height: 6.0,
                ),
              if (label != null)
                Text(
                  label!,
                  style: TextStyle(color: color, fontSize: labelSize),
                  textAlign: TextAlign.center,
                )
            ]),
      ),
    );
  }
}
