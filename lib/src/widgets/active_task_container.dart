import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:scout_spirit/src/modals/objective-select.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/tasks.dart';
import 'package:scout_spirit/src/utils/development_area.dart';
import 'package:scout_spirit/src/widgets/task_container.dart';

class ActiveTaskContainer extends StatefulWidget {
  @override
  _ActiveTaskContainerState createState() => _ActiveTaskContainerState();
}

class _ActiveTaskContainerState extends State<ActiveTaskContainer> {
  final double aspectRatio = 1.918;

  @override
  void initState() {
    super.initState();
    TasksService().getActiveTask();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width * 0.75;
    double height = width / aspectRatio;

    return StreamBuilder<Task?>(
        stream: TasksService().activeTask,
        builder: (context, snapshot) {
          Task? task = snapshot.data;
          return task == null
              ? _buildEmptyContainer(height, width, context)
              : _buildTaskContainer(task, height, width, context);
        });
  }

  Widget _buildTaskContainer(
      Task task, double height, double width, BuildContext context) {
    Objective objective = task.personalObjective;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      StreamBuilder<User?>(
          stream: AuthenticationService().userStream,
          builder: (context, snapshot) {
            User? user = snapshot.data;
            return snapshot.hasData
                ? Container(
                    width: width,
                    height: height,
                    child: Hero(
                      tag: "${objective.line}.${objective.subline}",
                      child: TaskContainer(
                        task: task,
                        unit: user!.unit,
                        onTap: () => _onTaskTap(context, user),
                        iconSize: height * 1.5,
                      ),
                    ))
                : Center(child: CircularProgressIndicator());
          }),
    ]);
  }

  Widget _buildEmptyContainer(
      double height, double width, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DottedBorder(
          borderType: BorderType.RRect,
          color: Colors.white,
          radius: Radius.circular(12.0),
          strokeWidth: 1.2,
          dashPattern: [8, 3],
          child: Container(
            height: height,
            width: width,
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.1, vertical: height * 0.1),
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 4,
                  child: RawMaterialButton(
                    onPressed: () => _onCreate(context),
                    elevation: 2.0,
                    fillColor: Color.fromRGBO(71, 48, 207, 1),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                    shape: CircleBorder(),
                  ),
                ),
                SizedBox(
                  width: 24.0,
                ),
                Expanded(
                  flex: 12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('¡Atención!',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Neucha',
                              fontSize: 21.0)),
                      SizedBox(height: 12.0),
                      Text(
                        'No tienes seleccionado un objetivo de progresión activo',
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> _onCreate(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) => ObjectiveSelectModal(
            closeOnSelect: true,
            onSelect: (area) => _onAreaSelect(context, area)));
  }

  Future<void> _onAreaSelect(BuildContext context, DevelopmentArea area) async {
    await Navigator.of(context).pushNamed('/tasks/start', arguments: area);
  }

  void _onTaskTap(BuildContext context, User user) {
    Navigator.of(context).pushNamed('/tasks/view', arguments: <String, dynamic>{
      'isActive': true,
      'task': user.beneficiary!.target,
      'unit': user.unit,
      'editable': false
    });
  }
}
