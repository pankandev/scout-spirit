import 'package:flutter/material.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/utils/colors.dart';
import 'package:scout_spirit/src/utils/development_area.dart';
import 'package:scout_spirit/src/utils/objectives_icons.dart';

class AreasGrid extends StatelessWidget {
  final bool Function(DevelopmentArea area)? greyBuilder;
  final bool Function(DevelopmentArea area)? disabledBuilder;
  final void Function(DevelopmentArea area)? onAreaPressed;

  const AreasGrid(
      {Key? key,
      required this.onAreaPressed,
      this.greyBuilder,
      this.disabledBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return GridView.count(
      crossAxisCount: 2,
      children: DevelopmentArea.values.map((area) {
        AreaDisplayData display = ObjectivesDisplay.getUserAreaIconData(
            AuthenticationService().snapAuthenticatedUser!, area);
        bool isDisabled = onAreaPressed == null ||
            (disabledBuilder != null && disabledBuilder!(area));
        bool isGrey = greyBuilder != null && greyBuilder!(area);
        return RawMaterialButton(
            fillColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.white54,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            onPressed: isDisabled ? null : () => onAreaPressed!(area),
            padding: EdgeInsets.zero,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                      isGrey ? getGreyColor(display.color) : display.color,
                      isGrey
                          ? getGreyColor(display.accentColor)
                          : display.accentColor
                    ],
                        stops: [
                      0,
                      1
                    ])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(display.icon, color: Colors.white, size: 0.2 * screenSize.width),
                    SizedBox(height: 12.0),
                    Text(
                      display.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontFamily: 'ConcertOne'),
                    )
                  ],
                ),
              ),
            ));
      }).toList(),
    );
  }
}
