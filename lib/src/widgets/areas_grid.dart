import 'package:flutter/material.dart';
import 'package:scout_spirit/src/services/authentication.dart';
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
    return GridView.count(
      crossAxisCount: 2,
      children: DevelopmentArea.values.map((area) {
        AreaDisplayData display = ObjectivesDisplay.getUserAreaIconData(
            AuthenticationService().snapAuthenticatedUser!, area);
        bool isDisabled = onAreaPressed == null ||
            (disabledBuilder != null && disabledBuilder!(area));
        bool isGrey = greyBuilder != null && greyBuilder!(area);
        return TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.white.withAlpha(72)),
              shape: MaterialStateProperty.resolveWith((states) =>
                  RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => isGrey ? display.disabledColor : display.color),
            ),
            onPressed: isDisabled ? null : () => onAreaPressed!(area),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(64.0),
                  child: Column(
                    children: [
                      Icon(display.icon, color: Colors.white, size: 256.0),
                      SizedBox(height: 64.0),
                      Text(
                        display.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 48.0,
                            fontFamily: 'ConcertOne'),
                      )
                    ],
                  ),
                )));
      }).toList(),
    );
  }
}
