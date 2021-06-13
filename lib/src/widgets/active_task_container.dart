import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/tasks.dart';
import 'package:scout_spirit/src/widgets/task_container.dart';
import 'package:scout_spirit/src/widgets/scout_outlined_button.dart';

class ActiveTaskContainer extends StatefulWidget {
  @override
  _ActiveTaskContainerState createState() => _ActiveTaskContainerState();
}

class _ActiveTaskContainerState extends State<ActiveTaskContainer> {
  @override
  void initState() {
    super.initState();
    TasksService().fetchActiveTask();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Task?>(
        stream: TasksService().activeTaskStream,
        builder: (context, snapshot) {
          Task? task = snapshot.data;
          return AspectRatio(
              aspectRatio: 1.918,
              child: task == null
                  ? _buildEmptyContainer(context)
                  : _buildTaskContainer(context, task));
        });
  }

  Widget _buildTaskContainer(BuildContext context, Task task) {
    Objective objective = task.personalObjective;
    return StreamBuilder<User?>(
        stream: AuthenticationService().userStream,
        builder: (context, snapshot) {
          User? user = snapshot.data;
          return snapshot.hasData
              ? Container(
                  child: Hero(
                  tag: "${objective.line}.${objective.subline}",
                  child: TaskContainer(
                    task: task,
                    unit: user!.unit,
                    onTap: () => _onTaskTap(context, user),
                  ),
                ))
              : Center(child: CircularProgressIndicator());
        });
  }

  Widget _buildEmptyContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white.withOpacity(0.28),
          border: Border.all(color: Colors.white.withOpacity(0.62))),
      padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 16.0),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      'No has indicado un ojetivo\nen progreso aun 😅',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'ConcertOne',
                          fontSize: 18.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Expanded(
                  child: ScoutOutlinedButton(
                    onPressed: () => _onCreate(context),
                    label: 'Comenzar un objetivo',
                    icon: Icons.edit,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 16.0,
          ),
          Expanded(
            flex: 4,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Icon(
                Icons.sentiment_dissatisfied_rounded,
                color: Colors.white.withOpacity(0.62),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onCreate(BuildContext context) async {
    await Navigator.of(context).pushNamed('/tasks/start');
  }

  void _onTaskTap(BuildContext context, User user) {
    Navigator.of(context).pushNamed('/tasks/active');
  }
}
