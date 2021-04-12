import 'package:flutter/material.dart';
import 'package:scout_spirit/src/widgets/areas_grid.dart';
import 'package:scout_spirit/src/utils/development_area.dart';

class ObjectiveSelectModal extends StatelessWidget {
  final Function(DevelopmentArea area)? onSelect;
  final bool closeOnSelect;

  ObjectiveSelectModal({this.onSelect, this.closeOnSelect = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
        ),
        body: AreasGrid(
            onAreaPressed: onSelect != null
                ? (area) {
                    if (closeOnSelect) {
                      Navigator.of(context).pop();
                    }
                    onSelect!(area);
                  }
                : null));
  }
}
