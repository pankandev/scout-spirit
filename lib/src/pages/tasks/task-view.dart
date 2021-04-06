import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/models/task.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/providers/provider_consumer.dart';
import 'package:scout_spirit/src/services/tasks.dart';
import 'package:scout_spirit/src/widgets/task_container.dart';

class TaskViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.blue),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: FutureBuilder<Task?>(
          future: TasksService().getActiveTask(),
          builder: (_, snapshot) => snapshot.hasData
              ? TaskView(
                  task: snapshot.data!,
                  unit: arguments['unit'],
                  isActive: arguments.containsKey('isActive')
                      ? arguments['isActive']
                      : false)
              : Center(child: CircularProgressIndicator()),
        ));
  }
}

class TaskView extends StatefulWidget {
  final bool isActive;
  final Task task;
  final Unit unit;
  final ValueNotifier<Task?> taskController = ValueNotifier<Task?>(null);

  TaskView(
      {Key? key, required this.task, required this.unit, this.isActive = false})
      : super(key: key) {
    taskController.value = task;
  }

  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  bool dirty = false;
  bool loading = false;
  bool completed = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Objective objective = widget.task.personalObjective;
    return SafeArea(
      child: Stack(children: [
        _buildForm(size, objective),
        if (widget.isActive) _buildSaveButton(context)
      ]),
    );
  }

  Container _buildForm(Size size, Objective objective) {
    return Container(
      height: size.height,
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: "${objective.line}.${objective.subline}",
              child: TaskContainer(
                  task: widget.task,
                  unit: widget.unit,
                  iconSize: (size.width / 1.918) * 1.5),
            ),
            _buildSubTasks(widget.task),
          ],
        ),
      ),
    );
  }

  Widget _buildSubTasks(Task task) {
    return widget.taskController.value == null
        ? Container()
        : ProviderConsumer<Task?>(
            controller: widget.taskController,
            builder: (controller) {
              Task task = controller.value!;
              return ListView(
                shrinkWrap: true,
                children: task.tasks.asMap().keys.map((index) {
                  final SubTask subtask = task.tasks[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CheckboxListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 18.0),
                            child: Text(subtask.description),
                          ),
                          value: subtask.completed,
                          onChanged: widget.isActive
                              ? (bool? value) =>
                                  _onSubTaskTap(task, index, value!)
                              : null),
                      Divider(
                        height: 1,
                      )
                    ],
                  );
                }).toList(),
              );
            },
          );
  }

  void _onSubTaskTap(Task task, int index, bool value) {
    SubTask subtask = task.tasks[index];
    List<SubTask> subtasks = task.tasks.map((e) => e).toList();
    subtasks[index] =
        SubTask(description: subtask.description, completed: value);
    widget.taskController.value = Task(
      score: task.score,
      created: task.created,
      completed: task.completed,
      originalObjective: task.originalObjective,
      personalObjective: task.personalObjective,
      tasks: subtasks,
    );
    setState(() {
      dirty = true;
      completed = subtasks.fold(true, (prev, task) => prev && task.completed);
    });
  }

  Widget _buildSaveButton(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isOriginalCompleted =
        widget.task.tasks.fold(true, (prev, next) => prev && next.completed);
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.only(bottom: 18.0),
          width: size.width * 0.8,
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: (dirty || isOriginalCompleted) && !loading
                      ? () => completed || isOriginalCompleted
                          ? _complete()
                          : _save()
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(completed ? 'Guardar y completar' : 'Guardar'),
                      if (loading)
                        FittedBox(
                            fit: BoxFit.contain,
                            child: CircularProgressIndicator())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _save() async {
    setState(() {
      loading = true;
    });
    Task task = widget.taskController.value!;
    try {
      await TasksService().updateActiveTask(task.tasks);
    } catch (e) {
      setState(() {
        dirty = false;
        loading = false;
      });
      throw e;
    }
    setState(() {
      dirty = false;
      loading = false;
    });
  }

  Future<void> _complete() async {
    setState(() {
      loading = true;
    });
    try {
      CompleteTaskResponse response = await TasksService().completeActiveTask();
    } catch (e) {
      setState(() {
        dirty = false;
        loading = false;
      });
      throw e;
    }
    Navigator.pop(context);
  }
}
