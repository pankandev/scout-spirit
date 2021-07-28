import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scout_spirit/src/themes/constants.dart';

class HeaderBack extends StatelessWidget {
  final String? label;
  final Function()? onBack;
  final Widget? trailing;

  const HeaderBack({Key? key, required this.onBack, this.label, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Paddings.left,
      child: Align(
        alignment: Alignment.centerLeft,
        child: RawMaterialButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.white12,
          onPressed: onBack,
          shape: Shapes.maxed,
          child: Padding(
            padding: Paddings.button,
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flex(
                  mainAxisSize: MainAxisSize.min,
                  direction: Axis.horizontal,
                  children: [
                    Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: IconSizes.medium,
                    ),
                    if (label != null)
                      Padding(
                        padding:
                        EdgeInsets.only(left: 16.0.sp, bottom: 21.0.sp),
                        // Padding to fix font alignment
                        child: Text(
                          label!,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'ConcertOne',
                              fontSize: FontSizes.medium),
                        ),
                      )
                  ],
                ),
                if (trailing != null) trailing!
              ],
            ),
          ),
        ),
      ),
    );
  }
}
