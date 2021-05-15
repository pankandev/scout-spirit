import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/task.dart';
import 'package:scout_spirit/src/models/log.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/tasks.dart';
import 'package:scout_spirit/src/services/logs.dart';
import 'package:scout_spirit/src/themes/theme.dart';
import 'package:scout_spirit/src/utils/datetime.dart';
import 'package:scout_spirit/src/widgets/background.dart';
import 'package:scout_spirit/src/widgets/header_back.dart';
import 'package:scout_spirit/src/widgets/task_container.dart';
import 'package:scout_spirit/src/providers/reward_provider.dart';
import 'package:scout_spirit/src/pages/progress_log.dart';

class TaskViewPage extends StatefulWidget {
  final bool editable;
  final Task task;

  const TaskViewPage({Key? key, required this.task, this.editable = false})
      : super(key: key);

  @override
  _TaskViewPageState createState() => _TaskViewPageState();
}

class _TaskViewPageState extends State<TaskViewPage> {
  final ValueNotifier<Task?> taskController = ValueNotifier<Task?>(null);
  Future<List<Log>> logs = Future.value([]);
  bool dirty = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _updateFutures();
  }

  Future<void> _updateFutures() async {
    Task? task = widget.task;
    setState(() {
      logs = LogsService().getProgressLogs(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: AuthenticationService().userStream,
        builder: (context, userSnapshot) {
          User? user = userSnapshot.data;
          Task task = widget.task;
          return user == null
              ? Center(child: CircularProgressIndicator())
              : StreamBuilder<FullTask>(
                  stream: TasksService().getTaskStream(
                      user.id, task.stage, task.area, task.line, task.subline),
                  builder: (context, snapshot) {
                    Task? task = snapshot.data;
                    bool? completed = task?.tasks.fold<bool>(
                        true, (prev, element) => prev && element.completed);
                    bool disabled = loading || !dirty;
                    return Scaffold(
                        backgroundColor: Colors.transparent,
                        floatingActionButton: isEditable
                            ? FloatingActionButton(
                                onPressed: task != null || disabled
                                    ? () => _openLogEditor()
                                    : null,
                                child: Icon(Icons.edit),
                                backgroundColor: Colors.pinkAccent,
                              )
                            : null,
                        body: Stack(
                          children: [
                            Background(),
                            SafeArea(
                              child: SingleChildScrollView(
                                  child: Column(
                                children: [
                                  HeaderBack(
                                      onBack: () => Navigator.of(context).pop(),
                                      label: 'Objetivo',
                                      trailing: isEditable
                                          ? IconButton(
                                              icon: Icon((completed ?? false)
                                                  ? Icons.check
                                                  : Icons.save),
                                              color: Colors.white,
                                              disabledColor: Colors.white54,
                                              onPressed: (completed ?? false)
                                                  ? _complete
                                                  : (dirty ? _save : null),
                                            )
                                          : null),
                                  (user != null && task != null)
                                      ? _buildTaskView(user.unit)
                                      : Center(
                                          child: CircularProgressIndicator())
                                ],
                              )),
                            )
                          ],
                        ));
                  },
                );
        });
  }

  bool get isEditable => widget.editable;

  Widget _buildTaskView(Unit unit) {
    Size size = MediaQuery.of(context).size;
    return Stack(children: [
      _buildForm(unit, size, isEditable),
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
              SizedBox(
                height: 16.0,
              ),
              Text(
                'Tareas',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontFamily: 'ConcertOne'),
              ),
              _buildSubTasks(isActive),
              Text(
                'Registros',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontFamily: 'ConcertOne'),
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
              children: task.tasks.length == 0
                  ? [_buildPlaceholder('Sin tareas definidas')]
                  : task.tasks.asMap().keys.map((index) {
                      final SubTask subtask = task.tasks[index];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 8.0,
                          ),
                          CheckboxListTile(
                              title: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 18.0),
                                child: Text(
                                  subtask.description,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'ConcertOne'),
                                ),
                              ),
                              selectedTileColor: Colors.white,
                              tileColor: Colors.white12,
                              activeColor: Colors.white,
                              checkColor: appTheme.primaryColor,
                              value: subtask.completed,
                              onChanged: isActive
                                  ? (bool? value) =>
                                      _onSubTaskTap(index, value!)
                                  : null),
                          Divider(
                            color: Colors.white,
                            height: 1,
                          )
                        ],
                      );
                    }).toList(),
            ),
          );
  }

  Widget _buildPlaceholder(String message) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.0),
      child: Text(
        message,
        style: TextStyle(
            color: Color.lerp(Colors.white, Colors.grey, 0.2),
            fontFamily: 'ConcertOne',
            fontSize: 18.0),
        textAlign: TextAlign.center,
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
            ? (snapshot.data!.length == 0
                ? _buildPlaceholder('Sin registros')
                : ListView.builder(
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
                    }))
            : Center(child: CircularProgressIndicator()));
  }
}
