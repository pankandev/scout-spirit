import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/world.dart';
import 'package:scout_spirit/src/services/world.dart';
import 'package:scout_spirit/src/widgets/alert_body.dart';

class NewZoneDialog extends StatefulWidget {
  @override
  _NewZoneDialogState createState() => _NewZoneDialogState();
}

class _NewZoneDialogState extends State<NewZoneDialog> {
  late final Stream<List<Zone>> zones;

  @override
  void initState() {
    super.initState();
    zones = WorldService().getAvailableZones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder<List<Zone>>(
          stream: zones,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Dialog(child: _buildBody(snapshot.data!))
                : Center(
                    child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ));
          }),
    );
  }

  Widget _buildBody(List<Zone> zones) {
    return zones.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              Zone zone = zones[index];
              return ListTile(
                leading: Text(zone.zoneId),
                onTap: () => Navigator.pop(context, zone),
              );
            },
            itemCount: zones.length)
        : AlertBody(
            title: 'Camino bloqueado 😮',
            body: '¡Desbloquea más zonas avanzando\nen tu bitácora!',
            onOk: () => Navigator.pop(context));
  }
}
