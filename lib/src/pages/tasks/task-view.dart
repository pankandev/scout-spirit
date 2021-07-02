import 'package:flutter/material.dart';
import 'package:scout_spirit/src/error/app_error.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/models/task.dart';
import 'package:scout_spirit/src/models/log.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/providers/loading_screen.dart';
import 'package:scout_spirit/src/providers/logger.dart';
import 'package:scout_spirit/src/providers/provider_consumer.dart';
import 'package:scout_spirit/src/providers/snackbar.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/tasks.dart';
import 'package:scout_spirit/src/themes/theme.dart';
import 'package:scout_spirit/src/utils/datetime.dart';
import 'package:scout_spirit/src/widgets/background.dart';
import 'package:scout_spirit/src/widgets/header_back.dart';
import 'package:scout_spirit/src/widgets/task_container.dart';
import 'package:scout_spirit/src/providers/reward_provider.dart';
import 'package:scout_spirit/src/pages/progress_log.dart';

class TaskViewPage extends StatefulWidget {
  final bool readonly;
  final ObjectiveKey? objectiveKey;

  const TaskViewPage(
      {Key? key, required this.objectiveKey, this.readonly = true})
      : super(key: key);

  @override
  _TaskViewPageState createState() => _TaskViewPageState();
}

class _TaskViewPageState extends State<TaskViewPage> {
  final ValueNotifier<Task?> taskController = ValueNotifier<Task?>(null);
  late final Stream<FullTask?> task;
  bool dirty = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();

    ObjectiveKey? key = objectiveKey;
    bool isActiveTask = key == null;

    Future<FullTask?> future;
    if (isActiveTask) {
      future = TasksService().fetchActiveTask();
      task = TasksService().activeTaskStream;
      print('active');
    } else {
      future = TasksService().fetchTask(
          AuthenticationService().authenticatedUserId,
          key.stage,
          key.area,
          key.line,
          key.subline);
      task = future.asStream();
      print('non-active');
    }

    future.then((task) {
      taskController.value = task;
    });
  }

  ObjectiveKey? get objectiveKey => widget.objectiveKey;

  bool get isActiveTask => objectiveKey == null;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: AuthenticationService().userStream,
        builder: (context, userSnapshot) {
          User? user = userSnapshot.data;
          return user == null
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CircularProgressIndicator(),
                ))
              : StreamBuilder<FullTask?>(
                  stream: task,
                  builder: (context, snapshot) {
                    FullTask? task = snapshot.data;
                    return Scaffold(
                        backgroundColor: Colors.transparent,
                        floatingActionButton: !readonly
                            ? FloatingActionButton(
                                onPressed: () => _openLogEditor(),
                                child: Icon(Icons.edit),
                                backgroundColor: Colors.pinkAccent,
                              )
                            : null,
                        body: Stack(
                          children: [
                            Background(),
                            SafeArea(
                              child: Column(
                                children: [
                                  ProviderConsumer<Task?>(
                                    controller: taskController,
                                    builder: (_) {
                                      bool completed = taskController
                                              .value?.tasks
                                              .fold<bool>(
                                                  true,
                                                  (prev, element) =>
                                                      prev &&
                                                      element.completed) ??
                                          false;
                                      return HeaderBack(
                                          onBack: () =>
                                              Navigator.of(context).pop(),
                                          label: 'Objetivo',
                                          trailing: !readonly
                                              ? IconButton(
                                                  icon: Icon(completed
                                                      ? Icons.check
                                                      : Icons.save),
                                                  color: Colors.white,
                                                  disabledColor: Colors.white54,
                                                  onPressed: completed
                                                      ? _complete
                                                      : (dirty ? _save : null),
                                                )
                                              : null);
                                    },
                                  ),
                                  (task != null)
                                      ? Expanded(
                                          child:
                                              _buildTaskView(user.unit, task))
                                      : Center(
                                          child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 128.0),
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.white),
                                          ),
                                        ))
                                ],
                              ),
                            )
                          ],
                        ));
                  },
                );
        });
  }

  bool get readonly => widget.readonly;

  Widget _buildTaskView(Unit unit, FullTask task) {
    return _buildForm(unit, task);
  }

  Widget _buildForm(Unit unit, FullTask task) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 26.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag:
                  "${task.originalObjective.line}.${task.originalObjective.subline}",
              child: TaskContainer(
                  task: task, unit: unit, iconSize: (size.width / 1.918) * 1.5),
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
            SizedBox(
              height: 16.0,
            ),
            _buildSubTasks(),
            Text(
              'Registros',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontFamily: 'ConcertOne'),
            ),
            SizedBox(
              height: 16.0,
            ),
            _buildOldLogs(task.logs),
          ],
        ),
      ),
    );
  }

  Widget _buildSubTasks() {
    Task? task = taskController.value;
    return task == null
        ? Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Center(child: CircularProgressIndicator()),
          )
        : Container(
            constraints: BoxConstraints(minHeight: 164.0),
            child: ProviderConsumer<Task?>(
              controller: taskController,
              builder: (_) {
                print(taskController.value?.tasks
                    .map((e) => e.completed)
                    .toList());
                return taskController.value == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: taskController.value!.tasks.length == 0
                            ? [_buildPlaceholder('Sin tareas definidas')]
                            : task.tasks.asMap().keys.map((index) {
                                final SubTask subtask =
                                    taskController.value!.tasks[index];
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
                                        onChanged: !readonly
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
                      );
              },
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
            fontFamily: 'UbuntuCondensed',
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
      rethrow;
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
      LoadingScreenProvider().show(context, label: "Completando objetivo...");
      await TasksService().completeActiveTask();
      LoadingScreenProvider().hide();
    } catch (e, s) {
      setState(() {
        dirty = true;
        loading = false;
      });
      LoadingScreenProvider().hide();
      await LoggerService().error(e, s);
      rethrow;
    }
    await RewardChecker().checkForRewards(context);
    Navigator.pop(context);
  }

  Future<void> _openLogEditor() async {
    if (!isActiveTask) {
      SnackBarProvider.showMessage(
          context, 'Sólo se puede abrir el editor en una tarea activa');
      throw new AppError(
          message: 'Can only open Log editor on the active task');
    }

    bool? newLog = await showDialog<bool>(
        context: context, builder: (context) => ProgressLogDialog());
    if (newLog != null && newLog) {
      setState(() {
        TasksService().fetchActiveTask(onlyLogs: true);
      });
    }
  }

  Widget _buildOldLogs(List<Log> logs) {
    return (logs.length == 0
        ? _buildPlaceholder('Sin registros')
        : ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: logs.length,
            itemBuilder: (context, index) {
              Log log = logs[index];
              final String day =
                  "${padZero(log.time.day, 2)}/${padZero(log.time.month, 2)}/${padZero(log.time.year, 4)}";
              final String hour =
                  "${padZero(log.time.hour, 2)}:${padZero(log.time.minute, 2)}:${padZero(log.time.second, 2)}";
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(
                      log.log,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text("$day $hour",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w300)),
                  ),
                  Divider()
                ],
              );
            }));
  }
}
