import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/log.dart';
import 'package:scout_spirit/src/themes/constants.dart';
import 'package:scout_spirit/src/themes/theme.dart';

class LogCard extends StatelessWidget {
  final Log log;

  const LogCard({Key? key, required this.log}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3.2,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadii.large,
            boxShadow: <BoxShadow>[Shadows.glow]),
        child: Stack(children: [
          Container(
            padding: Paddings.container,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                    flex: 1,
                    child: Icon(log.display.icon,
                        size: IconSizes.large, color: appTheme.primaryColor)),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: Paddings.bottom,
                    child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              log.timestampLabel,
                              style: TextStyles.muted
                                  .copyWith(fontSize: FontSizes.small),
                            ),
                            VSpacings.medium,
                            Text(
                              log.displayLog,
                              style: TextStyle(
                                  fontSize: FontSizes.medium,
                                  fontFamily: 'Ubuntu',
                                  fontWeight: FontWeight.w700,
                                  color: appTheme.primaryColor),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
