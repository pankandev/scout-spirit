import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:scout_spirit/src/models/task.dart';
import 'package:scout_spirit/src/widgets/header_back.dart';
import 'package:scout_spirit/src/widgets/task_start/task_edit_dialogue.dart';
import 'package:scout_spirit/src/forms/task_start.dart';

class TasksForm extends StatefulWidget {
  final Function(List<SubTask> tasks)? onChange;
  final Function()? onBack;

  TasksForm({Key? key, this.onChange, this.onBack}) : super(key: key);

  @override
  _TasksFormState createState() => _TasksFormState();
}

class _TasksFormState extends State<TasksForm> {
  List<SubTask> tasks = [];

  @override
  void initState() {
    super.initState();
    tasks = form.tasks;
  }

  TaskStartForm get form => Provider.of<TaskStartForm>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: ListView(
            children: <Widget>[
                  HeaderBack(
                    onBack: widget.onBack,
                    label: 'Concrétalo',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14.0),
                    child: Text(
                      'Tareas',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Ubuntu',
                          fontSize: 24.0),
                    ),
                  )
                ] +
                tasks
                    .asMap()
                    .keys
                    .map<Widget>((index) => Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildTaskCard(index),
                        ))
                    .toList() +
                (tasks.length < 6
                    ? <Widget>[_buildEmptyTaskBody()]
                    : <Widget>[])));
  }

  Widget _buildEmptyTaskBody() {
    return RawMaterialButton(
        onPressed: () => _addTask(),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(64.0),
            side: BorderSide(color: Colors.white, width: 3.0)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 32.0,
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildTaskCard(int index) {
    SubTask? task = index < tasks.length ? tasks[index] : null;
    return task == null
        ? _buildEmptyTaskBody()
        : Container(
            decoration: BoxDecoration(boxShadow: <BoxShadow>[
              BoxShadow(color: Colors.white24, blurRadius: 6.0)
            ], borderRadius: BorderRadius.circular(32.0), color: Colors.white),
            padding: EdgeInsets.only(right: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(218, 218, 218, 1)),
                    child: Icon(
                      Icons.check,
                      color: Color.fromRGBO(72, 72, 72, 1),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                        task.description.isNotEmpty
                            ? task.description
                            : 'Tarea vacía...',
                        style: task.description.isNotEmpty
                            ? TextStyle(fontFamily: 'Ubuntu', height: 1.15)
                            : TextStyle(
                                fontFamily: 'Ubuntu', color: Colors.grey)),
                  ),
                ),
                Flexible(
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: RawMaterialButton(
                          shape: CircleBorder(),
                          splashColor: Colors.blue.withOpacity(0.4),
                          padding: new EdgeInsets.all(0.0),
                          child: Icon(
                            Icons.edit,
                            color: Colors.blue,
                            size: 18.0,
                          ),
                          onPressed: () => _onEdit(index),
                        ),
                      ),
                      Flexible(
                        child: RawMaterialButton(
                          shape: CircleBorder(),
                          padding: new EdgeInsets.all(0.0),
                          splashColor: Colors.redAccent.withOpacity(0.4),
                          child: Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                            size: 18.0,
                          ),
                          onPressed: () => _deleteTask(index),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ));
  }

  void _addTask() {
    setState(() {
      tasks.add(SubTask(description: ''));
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
    String? content = await showDialog(
        context: context, builder: (context) => TaskEditDialogue());
    if (content == null) {
      return;
    }
    setState(() {
      tasks[index] = SubTask(description: content);
      _validateAndEmit();
    });
  }

  void _validateAndEmit() {
    form.tasks = tasks.map((e) => e).toList();
  }
}
