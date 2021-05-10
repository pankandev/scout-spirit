import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/task.dart';
import 'package:scout_spirit/src/models/log.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/providers/provider_consumer.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/tasks.dart';
import 'package:scout_spirit/src/services/logs.dart';
import 'package:scout_spirit/src/utils/datetime.dart';
import 'package:scout_spirit/src/utils/objectives_icons.dart';
import 'package:scout_spirit/src/widgets/task_container.dart';
import 'package:scout_spirit/src/providers/reward_provider.dart';
import 'package:scout_spirit/src/pages/progress_log.dart';

class TaskViewPage extends StatefulWidget {
  final Task? task;

  const TaskViewPage({Key? key, this.task}) : super(key: key);

  @override
  _TaskViewPageState createState() => _TaskViewPageState();
}

class _TaskViewPageState extends State<TaskViewPage> {
  final ValueNotifier<Task?> taskController = ValueNotifier<Task?>(null);
  late Future<bool> taskFuture;
  Future<List<Log>> logs = Future.value([]);
  bool dirty = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _initFutures();
  }

  Future<void> _initFutures() async {
    taskFuture = (widget.task != null
            ? Future.value(widget.task)
            : TasksService().getActiveTask())
        .then((value) {
      taskController.value = value;
      return value != null;
    });
    bool taskFound = await taskFuture;
    setState(() {
      logs = taskFound
          ? LogsService().getProgressLogs(taskController.value!)
          : logs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: taskFuture,
      builder: (_, taskSnapshot) {
        return StreamBuilder<User?>(
            stream: AuthenticationService().userStream,
            builder: (context, userSnapshot) {
              User? user = userSnapshot.data;
              return ProviderConsumer<Task?>(
                controller: taskController,
                builder: (controller) {
                  Task? task = taskController.value;
                  bool? completed = task?.tasks.fold<bool>(
                      true, (prev, element) => prev && element.completed);
                  bool disabled = loading || !dirty;
                  return Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        iconTheme: IconThemeData(color: Colors.white),
                        backgroundColor: (user != null && task != null)
                            ? ObjectivesDisplay.getAreaIconData(
                                    user.unit, task.originalObjective.area)
                                .colorScheme
                                .primary
                            : Colors.grey,
                        shadowColor: Colors.transparent,
                        actions: completed != null
                            ? [
                                TextButton(
                                    onPressed: disabled
                                        ? null
                                        : (completed
                                            ? () => _complete()
                                            : () => _save()),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        loading
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: FittedBox(
                                                    child:
                                                        CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Colors.white54),
                                                )),
                                              )
                                            : Icon(
                                                completed
                                                    ? Icons.check
                                                    : Icons.save,
                                                color: disabled
                                                    ? Colors.white54
                                                    : Colors.white,
                                              ),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Text(
                                          loading
                                              ? 'Guardando...'
                                              : (completed
                                                  ? 'Guardar y completar'
                                                  : 'Guardar'),
                                          style: TextStyle(
                                              color: disabled
                                                  ? Colors.white54
                                                  : Colors.white),
                                        ),
                                      ],
                                    ))
                              ]
                            : null,
                      ),
                      floatingActionButton: isActive ? FloatingActionButton(
                        onPressed: task != null ? () => _openLogEditor() : null,
                        child: Icon(Icons.edit),
                        backgroundColor: Colors.pinkAccent,
                      ) : null,
                      body: (user != null && task != null)
                          ? _buildTaskView(user.unit)
                          : Center(child: CircularProgressIndicator()));
                },
              );
            });
      },
    );
  }

  bool get isActive => widget.task == null;

  Widget _buildTaskView(Unit unit) {
    Size size = MediaQuery.of(context).size;
    return Stack(children: [
      _buildForm(unit, size, isActive),
    ]);
  }

  Container _buildForm(Unit unit, Size size, bool isActive) {
    Task task = taskController.value!;
    return Container(
      height: size.height,
      width: size.width,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 26.0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Hero(
                tag:
                    "${task.originalObjective.line}.${task.originalObjective.subline}",
                child: TaskContainer(
                    task: task,
                    unit: unit,
                    iconSize: (size.width / 1.918) * 1.5),
              ),
              _buildSubTasks(isActive),
              Text(
                'Registros',
                style: TextStyle(color: Colors.white, fontSize: 24.0),
              ),
              _buildOldLogs(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubTasks(bool isActive) {
    Task? task = taskController.value;
    return task == null
        ? Center(child: CircularProgressIndicator())
        : Container(
            constraints: BoxConstraints(minHeight: 164.0),
            child: ListView(
              physics: BouncingScrollPhysics(),
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
                        onChanged: isActive
                            ? (bool? value) => _onSubTaskTap(index, value!)
                            : null),
                    Divider(
                      height: 1,
                    )
                  ],
                );
              }).toList(),
            ),
          );
  }

  Future<void> _save() async {
    setState(() {
      loading = true;
    });
    try {
      await TasksService().updateActiveTask(taskController.value!.tasks);
    } catch (e) {
      setState(() {
        loading = false;
      });
      throw e;
    }
    setState(() {
      dirty = false;
      loading = false;
    });
  }

  void _onSubTaskTap(int index, bool value) {
    Task task = taskController.value!;
    SubTask subtask = task.tasks[index];
    List<SubTask> subtasks = task.tasks.map((e) => e).toList();
    subtasks[index] =
        SubTask(description: subtask.description, completed: value);
    taskController.value = Task(
      score: task.score,
      created: task.created,
      completed: task.completed,
      originalObjective: task.originalObjective,
      personalObjective: task.personalObjective,
      tasks: subtasks,
    );
    setState(() {
      dirty = true;
    });
  }

  Future<void> _complete() async {
    setState(() {
      loading = true;
    });
    try {
      await TasksService().completeActiveTask();
    } catch (e) {
      setState(() {
        dirty = true;
        loading = false;
      });
      throw e;
    }
    await RewardChecker().checkForRewards(context);
    Navigator.pop(context);
  }

  Future<void> _openLogEditor() async {
    Task task = taskController.value!;
    bool? newLog = await showDialog<bool>(
        context: context, builder: (context) => ProgressLogDialog());
    if (newLog != null && newLog) {
      setState(() {
        logs = LogsService().getProgressLogs(task);
      });
    }
  }

  Widget _buildOldLogs() {
    return FutureBuilder<List<Log>>(
        future: logs,
        builder: (context, snapshot) => snapshot.hasData
            ? ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Log log = snapshot.data![index];
                  final String day =
                      "${padZero(log.time.day, 2)}/${padZero(log.time.month, 2)}/${padZero(log.time.year, 4)}";
                  final String hour =
                      "${padZero(log.time.hour, 2)}:${padZero(log.time.minute, 2)}:${padZero(log.time.second, 2)}";
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text(log.log),
                        subtitle: Text("$day $hour"),
                      ),
                      Divider()
                    ],
                  );
                })
            : Center(child: CircularProgressIndicator()));
  }
}
