import 'package:flutter/material.dart';

class HeaderBack extends StatelessWidget {
  final String? label;
  final Function()? onBack;
  final Widget? trailing;

  const HeaderBack({Key? key, required this.onBack, this.label, this.trailing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.0,
      padding: EdgeInsets.only(left: 6.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RawMaterialButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.white12,
          onPressed: onBack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 12.0),
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
                      size: 32.0,
                    ),
                    if (label != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 6.0),
                        child: Text(
                          label!,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'ConcertOne',
                              fontSize: 21.0),
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
