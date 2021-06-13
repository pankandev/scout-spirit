import 'package:flutter/material.dart';
import 'package:scout_spirit/src/widgets/areas_grid.dart';
import 'package:scout_spirit/src/utils/development_area.dart';
import 'package:scout_spirit/src/widgets/background.dart';

class ObjectiveSelectModal extends StatelessWidget {
  final Function()? onBack;
  final Function(DevelopmentArea area)? onSelect;
  final bool closeOnSelect;

  ObjectiveSelectModal({this.onBack, this.onSelect, this.closeOnSelect = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0.0,
          title: Text('Elige un objetivo',
              style: TextStyle(fontFamily: 'ConcertOne')),
        ),
        body: Stack(
          children: [
            Background(),
            AreasGrid(
                onAreaPressed: onSelect != null
                    ? (area) {
                        if (closeOnSelect) {
                          Navigator.of(context).pop();
                        }
                        onSelect!(area);
                      }
                    : null),
          ],
        ));
  }
}
