import 'package:flutter/material.dart';

import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/utils/objectives_icons.dart';
import 'package:scout_spirit/src/services/authentication.dart';

class ObjectiveCard extends StatelessWidget {
  final Objective objective;
  final void Function()? onSelect;

  ObjectiveCard({required this.objective, this.onSelect});

  AreaDisplayData get areaData => ObjectivesDisplay.getAreaIconData(
      AuthenticationService().snapAuthenticatedUser!.unit, objective.area);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: <BoxShadow>[
        BoxShadow(
            color: Colors.white70, blurRadius: 8.0, spreadRadius: -1)
      ], borderRadius: BorderRadius.circular(12.0)),
      child: RawMaterialButton(
        onPressed: this.onSelect,
        fillColor: Color.lerp(Colors.white, areaData.color, 0.1),
        splashColor: areaData.color.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Stack(
          children: [
            if (onSelect != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.chevron_right,
                    color: areaData.color.withOpacity(0.3),
                    size: 64.0,
                  ),
                ],
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 48.0),
                    child: Text(
                      objective.authorizedObjective,
                      style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Ubuntu',
                          fontSize: 12.0),
                      textAlign: TextAlign.justify,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
