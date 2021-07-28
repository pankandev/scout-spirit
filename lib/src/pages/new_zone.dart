import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/world.dart';
import 'package:scout_spirit/src/services/world.dart';
import 'package:scout_spirit/src/themes/theme.dart';
import 'package:scout_spirit/src/widgets/alert_body.dart';

class NewZoneDialog extends StatefulWidget {
  @override
  _NewZoneDialogState createState() => _NewZoneDialogState();
}

class _NewZoneDialogState extends State<NewZoneDialog> {
  late final Stream<List<ZoneMeta>> zones$;

  @override
  void initState() {
    super.initState();
    zones$ = WorldService().getAvailableZones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<List<ZoneMeta>>(
                  stream: zones$,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? Container(
                            decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.white70, blurRadius: 7.0)
                                ],
                                borderRadius: BorderRadius.circular(24.0),
                                color: Colors.white),
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width / 2),
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            child: _buildBody(snapshot.data!))
                        : Center(
                            child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ));
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(List<ZoneMeta> zones) {
    return zones.length > 0
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    ZoneMeta zone = zones[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildZoneItem(zone, 1),
                    );
                  },
                  itemCount: zones.length),
            ],
          )
        : AlertBody(
            title: 'Camino bloqueado 😮',
            body: '¡Desbloquea más zonas avanzando\nen tu bitácora!',
            onOk: () => Navigator.pop(context));
  }

  Container _buildZoneItem(ZoneMeta zone, int count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 2.0),
          borderRadius: BorderRadius.circular(16.0)),
      child: Flex(
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                zone.emoji,
                style: TextStyle(
                    fontSize: 24.0, color: Colors.white, fontFamily: 'Ubuntu'),
              ),
              SizedBox(
                width: 8.0,
              ),
              Expanded(
                  child: Text(
                zone.name,
                style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.w600),
              )),
              Chip(
                label: Text(
                  count.toString(),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w800),
                ),
                backgroundColor: appTheme.primaryColor,
              )
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: zone.nodes.entries
                .map((entry) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: RawMaterialButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0)),
                          child: Text(
                            "${entry.value.emoji} ${entry.value.name}",
                            style: TextStyle(fontFamily: 'Ubuntu'),
                          ),
                          fillColor: Colors.white,
                          onPressed: () => Navigator.pop<ZoneConnection>(
                              context,
                              ZoneConnection(
                                  nodeId: entry.key, zone: zone.zone))),
                    ))
                .toList(),
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Wow! 😯 Se ha abierto un nuevo camino',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Ubuntu',
                fontSize: 20.0,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            '¿Hacia donde quieres que se dirija este camino a partir de ahora?',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Ubuntu', fontSize: 14.0),
          ),
          SizedBox(
            height: 14.0,
          ),
        ],
      ),
    );
  }
}
