import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/tasks.dart';
import 'package:scout_spirit/src/themes/constants.dart';
import 'package:scout_spirit/src/utils/objectives_icons.dart';
import 'package:scout_spirit/src/widgets/active_task_container.dart';
import 'package:scout_spirit/src/widgets/background.dart';
import 'package:scout_spirit/src/widgets/navigation_buttons.dart';
import 'package:scout_spirit/src/widgets/radar_chart.dart';
import 'package:scout_spirit/src/widgets/header_back.dart';
import 'package:scout_spirit/src/widgets/task_container.dart';

class BinnaclePage extends StatefulWidget {
  BinnaclePage({Key? key}) : super(key: key);

  @override
  _BinnaclePageState createState() => _BinnaclePageState();
}

class _BinnaclePageState extends State<BinnaclePage> {
  @override
  void initState() {
    super.initState();
    TasksService().updateUserTasks();
  }

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
                      label: 'Bitácora',
                      onBack: () => Navigator.pop(context),
                    ),
                    _buildHeader(user),
                    _buildBody(context, user),
                  ]));
                }),
          )
        ],
      ),
    );
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
            unit, beneficiary != null ? beneficiary.nTasks : TasksCount()));
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

  Widget _buildBody(BuildContext context, User? user) {
    return Container(
        padding: Paddings.containerXFluid,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NavigationButtons(
                labels: ['Bitácora', 'Estadísticas'],
                page: 0,
                onPageChange: (index) =>
                    Navigator.of(context).pushReplacementNamed('/stats')),
            VSpacings.xlarge,
            Text(
              'Objetivo en progreso',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'ConcertOne',
                  fontSize: FontSizes.medium),
            ),
            VSpacings.xlarge,
            ActiveTaskContainer(),
            VSpacings.xlarge,
            Text(
              'Objetivos cumplidos',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'ConcertOne',
                  fontSize: 24.0),
            ),
            VSpacings.large,
            user != null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StreamBuilder<List<Task>>(
                          stream: TasksService().userTasks,
                          builder: (context, snapshot) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: snapshot.hasData
                                  ? snapshot.data!
                                      .map((e) => Padding(
                                            padding: Paddings.listItem,
                                            child: TaskContainer(
                                                unit: user.unit,
                                                task: e,
                                                onTap: () => _onTaskTap(e),
                                                label: 'Ver registros'),
                                          ))
                                      .toList()
                                  : [
                                      Container(
                                        child: CircularProgressIndicator(),
                                      )
                                    ],
                            );
                          }),
                    ],
                  )
                : Container(child: CircularProgressIndicator())
          ],
        ));
  }

  void _onTaskTap(Task task) {
    Navigator.of(context).pushNamed('/tasks/view', arguments: task);
  }
}
