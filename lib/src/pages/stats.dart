import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/themes/constants.dart';
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
        padding: Paddings.containerFluid,
        constraints: BoxConstraints(maxHeight: Sizes.giant),
        child: user != null
            ? Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(flex: 4, child: _buildUserData(user)),
                  Expanded(flex: 5, child: _buildRadar(user)),
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
        bottomWidget: Padding(
          padding: Paddings.label,
          child: Text(
            'Mantén presionado uno de los íconos en el gráfico para ver su significado',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'UbuntuCondensed',
                fontSize: FontSizes.small),
            textAlign: TextAlign.center,
          ),
        ),
        constraints: BoxConstraints(minHeight: double.infinity),
        items: getCountValues(
            unit, beneficiary != null ? beneficiary.score : TasksCount()));
  }

  Iterable<RadarItem> getCountValues(Unit unit, TasksCount count) {
    return count.items.map((item) {
      AreaDisplayData displayData =
          ObjectivesDisplay.getAreaIconData(unit, item.area);
      return RadarItem(
          label: displayData.name,
          value: item.value.toDouble(),
          icon: displayData.icon);
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
                  height: 0.9,
                  color: Colors.white,
                  fontSize: FontSizes.xlarge,
                  fontFamily: 'ConcertOne')),
          VSpacings.large,
          Text('${beneficiary?.totalScore ?? 0} puntos',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: FontSizes.medium,
                  fontFamily: fonts.label,
                  fontWeight: FontWeight.w700))
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
                VSpacings.medium,
                Text(
                  'Estadísticas',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'ConcertOne',
                      fontSize: FontSizes.large),
                ),
                VSpacings.medium,
                Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          tooltip:
                              'Mientras mayor sea tu Factor de Desarrollo Integral, significa que has progresado de forma más integra en las diferentes áreas de desarrollo.\n\n¡Avanza lo más posible en diferentes áreas para mejorar este valor!',
                        )),
                    Expanded(
                        flex: 2,
                        child: LabelValue(
                          label: 'Objetivos completados',
                          value: beneficiary.nTasks.total,
                        )),
                  ],
                ),
                VSpacings.medium,
                Text(
                  'Puntajes',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'ConcertOne',
                      fontSize: FontSizes.large),
                ),
                VSpacings.large,
                _buildStatsBoxes(beneficiary.score),
                SizedBox(
                  height: 16.0,
                ),
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
                        child: Padding(padding: Paddings.allXSmall, child: e)))
                    .toList()))
            .toList());
  }
}
