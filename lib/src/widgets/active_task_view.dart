import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/pages/tasks/task-view.dart';
import 'package:scout_spirit/src/services/tasks.dart';

class ActiveTaskView extends StatefulWidget {
  const ActiveTaskView({Key? key}) : super(key: key);

  @override
  _ActiveTaskViewState createState() => _ActiveTaskViewState();
}

class _ActiveTaskViewState extends State<ActiveTaskView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Task?>(
        stream: TasksService().activeTask,
        builder: (context, snapshot) => snapshot.hasData
            ? TaskViewPage(
                task: snapshot.data!,
                editable: true,
              )
            : Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ));
  }
}
