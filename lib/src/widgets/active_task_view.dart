import 'package:flutter/material.dart';
import 'package:scout_spirit/src/pages/tasks/task-view.dart';
import 'package:scout_spirit/src/services/tasks.dart';

class ActiveTaskView extends StatefulWidget {
  const ActiveTaskView({Key? key}) : super(key: key);

  @override
  _ActiveTaskViewState createState() => _ActiveTaskViewState();
}

class _ActiveTaskViewState extends State<ActiveTaskView> {
  @override
  void initState() {
    super.initState();
    TasksService().fetchActiveTask();
  }

  @override
  Widget build(BuildContext context) {
    return TaskViewPage(readonly: false, objectiveKey: null);
  }
}
