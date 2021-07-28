import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:scout_spirit/src/models/task.dart';
import 'package:scout_spirit/src/themes/constants.dart';
import 'package:scout_spirit/src/widgets/header_back.dart';
import 'package:scout_spirit/src/widgets/task_item.dart';
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
                    padding: Paddings.label,
                    child: Text(
                      'Tareas',
                      style:
                          TextStyles.titleLight.copyWith(fontFamily: 'Ubuntu'),
                    ),
                  )
                ] +
                tasks
                    .asMap()
                    .keys
                    .map<Widget>((index) => Padding(
                          padding: Paddings.listItem,
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
            borderRadius: BorderRadii.max,
            side: BorderSide(color: Colors.white, width: Dimensions.xsmall)),
        child: Container(
          padding: Paddings.buttonLoose,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: IconSizes.large,
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
        : TaskItem(task: task, onEdit: () => _onEdit(index), onDelete: () => _deleteTask(index),);
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
