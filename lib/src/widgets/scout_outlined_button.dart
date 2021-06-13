import 'package:flutter/material.dart';

class ScoutOutlinedButton extends StatelessWidget {
  final String label;
  final Function()? onPressed;
  final Color color;
  final EdgeInsets padding;
  final IconData? icon;
  final double borderWidth;
  final double labelSize;

  const ScoutOutlinedButton(
      {Key? key,
      required this.onPressed,
      required this.label,
      this.icon,
      this.labelSize = 16.0,
      this.padding =
          const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
      this.color = Colors.white,
      this.borderWidth = 3.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: color, width: borderWidth)),
      onPressed: onPressed,
      highlightColor: Colors.transparent,
      splashColor: color.withOpacity(0.12),
      padding: padding.copyWith(bottom: padding.bottom + 4.0),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: Text(
            label,
            style: TextStyle(
                color: color,
                fontFamily: 'ConcertOne',
                fontSize: this.labelSize),
          )),
          SizedBox(
            width: 12.0,
          ),
          if (icon != null)
            Icon(
              icon!,
              color: color,
            )
        ],
      ),
    );
  }
}
