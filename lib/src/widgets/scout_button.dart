import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scout_spirit/src/themes/constants.dart';

class ScoutButton extends StatelessWidget {
  final Color fillColor;
  final Color accentColor;
  final Color labelColor;
  final EdgeInsets? padding;
  final Alignment gradientCenter;
  final Function()? onPressed;

  final double? accentRadius;
  final double spreadRadius;
  final double blurRadius;
  final double labelSize;
  final double? iconSize;
  final double shadowAlpha;
  final BorderRadius? borderRadius;
  final String label;
  final IconData? icon;
  final MainAxisSize mainAxisSize;

  ScoutButton(
      {Key? key,
      required this.onPressed,
      required this.label,
      this.fillColor = Colors.white,
      this.accentColor = Colors.white,
      this.labelColor = const Color.fromRGBO(93, 36, 255, 1),
      this.labelSize = 48.0,
      this.spreadRadius = 1.0,
      this.accentRadius,
      this.gradientCenter = const Alignment(0.0, -2.0),
      this.blurRadius = 3.0,
      this.borderRadius,
      this.shadowAlpha = 0.4,
      this.mainAxisSize = MainAxisSize.min,
      this.icon,
      this.padding,
      this.iconSize})
      : super(key: key);

  EdgeInsets get effectivePadding => padding ?? Paddings.button;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: effectivePadding.copyWith(bottom: effectivePadding.bottom + 4.0),
      fillColor: fillColor,
      focusColor: fillColor,
      splashColor: Color.lerp(fillColor, Colors.black, 0.3),
      highlightColor: Color.lerp(fillColor, Colors.black, 0.1),
      elevation: 0.0,
      highlightElevation: 2.0,
      shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadii.max),
      onPressed: onPressed,
      child: Container(
        constraints: BoxConstraints(minWidth: double.infinity),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: icon != null
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: [
            if (label.isNotEmpty)
              Expanded(
                flex: 1,
                child: Text(
                  label,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: labelSize.sp,
                      fontWeight: FontWeight.w700,
                      color: labelColor,
                      fontFamily: 'Ubuntu'),
                ),
              ),
            if (icon != null)
              Icon(
                icon!,
                color: labelColor,
                size: (iconSize ?? (labelSize + 6.0)).sp,
              )
          ],
        ),
      ),
    );
  }
}
