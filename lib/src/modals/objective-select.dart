import 'package:flutter/material.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/utils/objectives_icons.dart';
import 'package:scout_spirit/src/utils/development_area.dart';

class ObjectiveSelectModal extends StatelessWidget {
  final Function(DevelopmentArea area) onSelect;

  ObjectiveSelectModal({this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _buildBackdrop(context),
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: _buildSelectGrid(context))
        ],
      ),
    );
  }

  GestureDetector _buildBackdrop(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        color: Colors.black.withAlpha(64),
      ),
    );
  }

  Widget _buildSelectGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
              shadowColor: Colors.white,
              child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                  child: Text(
                    'Selecciona de qué area de desarrollo quieres realizar un objetivo',
                    textAlign: TextAlign.center,
                  ))),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                children: ObjectivesDisplay.getUserAreasIconData(
                        AuthenticationService().snapAuthenticatedUser)
                    .map<Widget>((area) => _buildAreaIcon(context, area))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaIcon(BuildContext context, AreaDisplayData areaData) {
    return FittedBox(
        fit: BoxFit.contain,
        child: Column(
          children: [
            RawMaterialButton(
              onPressed: () async {
                Navigator.of(context).pop();
                this.onSelect(areaData.area);
              },
              elevation: 8.0,
              fillColor: areaData.color,
              child: FittedBox(
                  fit: BoxFit.fill,
                  child: Icon(areaData.icon, color: Colors.white)),
              padding: EdgeInsets.all(8.0),
              shape: CircleBorder(),
            ),
            SizedBox(
              height: 2.0,
            ),
            Text(
              areaData.name,
              style: TextStyle(
                  fontSize: 8.0, color: Colors.white, fontFamily: 'Neucha'),
            )
          ],
        ));
  }
}
