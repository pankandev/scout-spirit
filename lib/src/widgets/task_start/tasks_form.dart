import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:provider/provider.dart';

import 'package:scout_spirit/src/models/task.dart';
import 'package:scout_spirit/src/themes/theme.dart';
import 'package:scout_spirit/src/widgets/task_start/task_edit_dialogue.dart';
import 'package:scout_spirit/src/forms/task_start.dart';

class TasksForm extends StatefulWidget {
  final Function(List<Task> tasks) onChange;

  TasksForm({Key key, this.onChange}) : super(key: key);

  @override
  _TasksFormState createState() => _TasksFormState();
}

class _TasksFormState extends State<TasksForm> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    tasks = form.tasks;
    if (tasks == null) {
      tasks = [];
    }
  }

  TaskStartForm get form => Provider.of<TaskStartForm>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
          height: 288.0,
          child: Card(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: tasks
                          .asMap()
                          .keys
                          .map((index) => _buildTaskCard(index))
                          .toList() +
                      (tasks.length < 3 ? [_buildEmptyTaskBody()] : [])),
            ),
          )),
    );
  }

  Widget _buildEmptyTaskBody() {
    return Card(
        shadowColor: Colors.transparent,
        borderOnForeground: true,
        child: InkWell(
          onTap: () => _addTask(),
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: DottedBorder(
            borderType: BorderType.RRect,
            color: Colors.black12,
            radius: Radius.circular(12.0),
            strokeWidth: 0.8,
            dashPattern: [8, 3],
            child: Container(
              height: 60.0,
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Icon(Icons.add, color: Colors.black26),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildTaskCard(int index) {
    Task task = index < tasks.length ? tasks[index] : null;
    return task == null
        ? _buildEmptyTaskBody()
        : Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
                height: 60.0,
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        task.description.isNotEmpty
                            ? task.description
                            : 'Tarea vacía...',
                        style: task.description.isNotEmpty
                            ? null
                            : mutedTextTheme.copyWith(color: Colors.black26),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 18.0,
                          padding: new EdgeInsets.all(0.0),
                          icon: Icon(
                            Icons.edit,
                            color: Colors.lightBlue[200],
                          ),
                          onPressed: () => _onEdit(index),
                        ),
                        IconButton(
                          iconSize: 18.0,
                          padding: new EdgeInsets.all(0.0),
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red[300],
                          ),
                          onPressed: () => _deleteTask(index),
                        )
                      ],
                    ),
                  ],
                )),
          );
  }

  void _addTask() {
    setState(() {
      tasks.add(Task(description: ''));
      _onEdit(tasks.length - 1);
      _validateAndEmit();
    });
  }

  void _deleteTask(int index) {
    setState(() {
      this.tasks.removeAt(index);
      _validateAndEmit();
    });
  }

  Future<void> _onEdit(int index) async {
    String content =
        await showDialog(context: context, child: TaskEditDialogue());
    if (content == null) {
      return;
    }
    setState(() {
      tasks[index] = Task(description: content);
      _validateAndEmit();
    });
  }

  void _validateAndEmit() {
    form.tasks = tasks;
  }
}
