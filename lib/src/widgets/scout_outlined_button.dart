import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scout_spirit/src/themes/constants.dart';

class ScoutOutlinedButton extends StatelessWidget {
  final String label;
  final Function()? onPressed;
  final Color color;
  final EdgeInsets? padding;
  final IconData? icon;
  final double borderWidth;
  final double labelSize;
  final double borderRadius;

  const ScoutOutlinedButton(
      {Key? key,
      required this.onPressed,
      required this.label,
      this.icon,
      this.labelSize = 48.0,
      this.borderRadius = 16,
      this.padding,
      this.color = Colors.white,
      this.borderWidth = 3.0})
      : super(key: key);

  EdgeInsets get effectivePadding => padding ?? Paddings.button;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: effectivePadding.copyWith(bottom: effectivePadding.bottom + 4.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadii.max,
          side: BorderSide(color: color, width: borderWidth)),
      onPressed: onPressed,
      highlightColor: Colors.transparent,
      splashColor: color.withOpacity(0.12),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: color,
                fontFamily: 'Ubuntu',
                fontSize: labelSize.sp),
          )),
          VSpacings.medium,
          if (icon != null)
            Icon(
              icon!,
              color: color,
              size: (labelSize + 6.0).sp,
            )
        ],
      ),
    );
  }
}
