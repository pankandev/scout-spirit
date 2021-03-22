import 'package:flutter/material.dart';

import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/utils/objectives_icons.dart';
import 'package:scout_spirit/src/services/authentication.dart';

class ObjectiveCard extends StatelessWidget {
  final Objective objective;
  final Function onSelect;

  ObjectiveCard({this.objective, this.onSelect});

  AreaDisplayData get areaData => ObjectivesDisplay.getAreaIconData(
      AuthenticationService().snapAuthenticatedUser.unit, objective.area);

  @override
  Widget build(BuildContext context) {
    TextStyle muteTextStyle = TextStyle(fontSize: 12.0, color: Colors.black45);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    objective.authorizedObjective,
                    style: TextStyle(color: Colors.black54),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: [
                      Text('Línea: ${objective.line}.${objective.subline}',
                          style: muteTextStyle),
                    ],
                  )
                ],
              ),
            ),
            if (onSelect != null) IconButton(
              icon: Icon(Icons.arrow_forward),
              color: Colors.black45,
              onPressed: this.onSelect,
            )
          ],
        ),
      ),
    );
  }
}
