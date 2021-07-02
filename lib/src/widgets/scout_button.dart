import 'package:flutter/material.dart';
import 'package:scout_spirit/src/utils/colors.dart';

class ScoutButton extends StatelessWidget {
  final Color fillColor;
  final Color accentColor;
  final Color labelColor;
  final EdgeInsets padding;
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

  final BorderRadius _defaultBorderRadius = BorderRadius.circular(8.0);

  ScoutButton(
      {Key? key,
      required this.onPressed,
      required this.label,
      this.fillColor = Colors.white,
      this.accentColor = Colors.white,
      this.labelColor = const Color.fromRGBO(93, 36, 255, 1),
      this.labelSize = 16.0,
      this.spreadRadius = 1.0,
      this.accentRadius,
      this.gradientCenter = const Alignment(0.0, -2.0),
      this.blurRadius = 7.0,
      this.borderRadius,
      this.shadowAlpha = 0.4,
      this.mainAxisSize = MainAxisSize.min,
      this.icon,
      this.padding =
          const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
      this.iconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: EdgeInsets.zero,
      fillColor: Colors.red,
      splashColor: Colors.white,
      elevation: 0.0,
      highlightElevation: 10.0,
      shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? _defaultBorderRadius),
      onPressed: onPressed,
      child: Container(
        constraints: BoxConstraints(minWidth: double.infinity),
        decoration: BoxDecoration(
            borderRadius: borderRadius ?? _defaultBorderRadius,
            gradient: accentRadius != null
                ? RadialGradient(
                    center: gradientCenter,
                    radius: accentRadius!,
                    colors: onPressed != null
                        ? [fillColor, accentColor]
                        : [getGreyColor(fillColor), getGreyColor(accentColor)],
                    stops: [0, 1],
                  )
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: onPressed != null
                        ? [fillColor, accentColor]
                        : [getGreyColor(fillColor), getGreyColor(accentColor)],
                    stops: [0, 1]),
            boxShadow: [
              BoxShadow(
                  color:
                      (onPressed != null ? fillColor : getGreyColor(fillColor))
                          .withAlpha((shadowAlpha * 255).round()),
                  blurRadius: blurRadius,
                  spreadRadius: spreadRadius)
            ]),
        padding: padding.copyWith(bottom: padding.bottom + 4.0),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: icon != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
          children: [
            if (label.isNotEmpty)
              Expanded(
                flex: 1,
                child: Text(
                  label,
                  style: TextStyle(
                      fontSize: labelSize * 0.88,
                      fontWeight: FontWeight.w700,
                      color: labelColor,
                      fontFamily: 'Ubuntu'),
                ),
              ),
            if (icon != null && label.isNotEmpty)
              SizedBox(
                width: 16.0,
              ),
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Icon(
                  icon!,
                  color: labelColor,
                  size: iconSize ?? (labelSize + 6.0),
                ),
              )
          ],
        ),
      ),
    );
  }
}
