import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/utils/objectives_icons.dart';
import 'package:scout_spirit/src/utils/num.dart';
import 'package:scout_spirit/src/widgets/background.dart';
import 'package:scout_spirit/src/widgets/header_back.dart';
import 'package:scout_spirit/src/widgets/navigation_buttons.dart';
import 'package:scout_spirit/src/widgets/radar_chart.dart';
import 'package:scout_spirit/src/widgets/label_value.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          SafeArea(
            child: StreamBuilder<User?>(
                stream: AuthenticationService().userStream,
                builder: (context, snapshot) {
                  User? user = snapshot.data;
                  return SingleChildScrollView(
                      child: Column(children: [
                    HeaderBack(
                      label: 'Estadísticas',
                      onBack: () => Navigator.pop(context),
                    ),
                    _buildHeader(user),
                    _buildBody(context, user?.beneficiary),
                  ]));
                }),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(User? user) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        constraints: BoxConstraints(minHeight: 196.0, maxHeight: 240.0),
        child: user != null
            ? Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(child: _buildUserData(user)),
                  Expanded(child: _buildRadar(user)),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  Widget _buildRadar(User user) {
    Beneficiary? beneficiary = user.beneficiary;
    Unit unit = user.unit;
    return RadarChart(
        constraints: BoxConstraints(minHeight: double.infinity),
        items: getCountValues(
            unit, beneficiary != null ? beneficiary.score : TasksCount()));
  }

  Iterable<RadarItem> getCountValues(Unit unit, TasksCount count) {
    return count.items.map((item) {
      AreaDisplayData displayData =
          ObjectivesDisplay.getAreaIconData(unit, item.area);
      return RadarItem(label: displayData.name, value: item.value.toDouble());
    });
  }

  Widget _buildUserData(User user) {
    Beneficiary? beneficiary = user.beneficiary;
    return Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(beneficiary?.fullName ?? user.name,
              style: TextStyle(
                  color: Colors.white, fontSize: 28, fontFamily: 'ConcertOne')),
          SizedBox(
            height: 8.0,
          ),
          Text('${beneficiary?.totalScore ?? 0} puntos',
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontFamily: 'ConcertOne'))
        ]);
  }

  Widget _buildBody(BuildContext context, Beneficiary? beneficiary) {
    return Container(
      child: beneficiary == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NavigationButtons(
                    labels: ['Bitácora', 'Estadísticas'],
                    page: 1,
                    onPageChange: (index) => Navigator.of(context)
                        .pushReplacementNamed('/binnacle')),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  'Estadísticas',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'ConcertOne',
                      fontSize: 32.0),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                        flex: 2,
                        child: LabelValue(
                          label: 'Puntaje total',
                          value: beneficiary.score.total,
                        )),
                    Expanded(
                        flex: 3,
                        child: LabelValue(
                          label: 'Factor de Desarrollo Integral',
                          value:
                              '${roundToDigits(beneficiary.nTasks.integrityFactor, 2)}%',
                        )),
                    Expanded(
                        flex: 2,
                        child: LabelValue(
                          label: 'Objetivos completados',
                          value: beneficiary.nTasks.total,
                        )),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  'Puntajes',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'ConcertOne',
                      fontSize: 32.0),
                ),
                SizedBox(
                  height: 16.0,
                ),
                _buildStatsBoxes(beneficiary.score)
              ],
            ),
      padding: EdgeInsets.symmetric(horizontal: 21.0),
    );
  }

  Widget _buildStatsBoxes(TasksCount count) {
    List<List<Widget>> elements = [
      [
        LabelValueBox(
          label: 'Corporalidad',
          value: count.corporality,
        ),
        LabelValueBox(
          label: 'Creatividad',
          value: count.creativity,
        ),
        LabelValueBox(
          label: 'Carácter',
          value: count.character,
        ),
      ],
      [
        LabelValueBox(
          label: 'Afectividad',
          value: count.affectivity,
        ),
        LabelValueBox(
          label: 'Social',
          value: count.sociability,
        ),
        LabelValueBox(
          label: 'Espiritualidad',
          value: count.spirituality,
        ),
      ]
    ];
    return Flex(
        direction: Axis.vertical,
        children: elements
            .map((e) => Flex(
                mainAxisSize: MainAxisSize.min,
                direction: Axis.horizontal,
                children: e
                    .map((e) => Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 6.5),
                            child: e)))
                    .toList()))
            .toList());
  }
}
