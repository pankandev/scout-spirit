import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:scout_spirit/src/error/app_error.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/log.dart';
import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/models/reward_token.dart';
import 'package:scout_spirit/src/models/task.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/services/logs.dart';
import 'package:scout_spirit/src/services/rest_api.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/rewards.dart';
import 'package:scout_spirit/src/utils/development_area.dart';
import 'package:scout_spirit/src/utils/development_stage.dart';

class CompleteTaskResponse {
  RewardToken reward;
  Task task;

  CompleteTaskResponse.fromMap(Map<String, dynamic> map)
      : reward = RewardToken(map["reward"]),
        task = Task.fromMap(map["task"]);
}

final List<Task> testTasks = [
  Task(
      score: 32,
      originalObjective: Objective.fromCode('puberty::corporality::1.1')
          .copyWith(objective: 'Original objective 1'),
      personalObjective: Objective.fromCode('puberty::corporality::1.2')
          .copyWith(objective: 'Personal objective 1'),
      tasks: []),
  Task(
      score: 32,
      originalObjective: Objective.fromCode('puberty::affectivity::1.1')
          .copyWith(objective: 'Original objective 2'),
      personalObjective: Objective.fromCode('puberty::affectivity::1.2')
          .copyWith(objective: 'Personal objective 2'),
      tasks: []),
  Task(
      score: 32,
      originalObjective: Objective.fromCode('puberty::spirituality::1.1')
          .copyWith(objective: 'Original objective 2'),
      personalObjective: Objective.fromCode('puberty::spirituality::1.2')
          .copyWith(objective: 'Personal objective 2'),
      tasks: []),
];

// DevelopmentStage stage, DevelopmentArea area, int line, int subline
class TasksService extends RestApiService {
  final BehaviorSubject<FullTask?> activeTaskSubject =
      BehaviorSubject<FullTask?>();

  Stream<FullTask?> get activeTaskStream => activeTaskSubject.stream;

  FullTask? get snapActiveTask => activeTaskSubject.value;

  static TasksService _instance = TasksService._internal();

  TasksService._internal() : cache = {};

  final Map<
      String,
      Map<
          DevelopmentStage,
          Map<DevelopmentArea,
              Map<int, Map<int, BehaviorSubject<FullTask>>>>>> cache;

  factory TasksService() {
    return _instance;
  }

  Future<void> startObjective(
      Objective personalObjective, List<SubTask> tasks) async {
    if (tasks.length == 0) throw new AppError(message: 'Tasks list is empty');
    User user = AuthenticationService().authenticatedUser;
    Map<String, dynamic> payload = {
      "sub-tasks": tasks.map((e) => e.description).toList(),
      "description": personalObjective.rawObjective
    };
    await post(
        'api/users/${user.id}/tasks/${user.stageName}/${personalObjective.areaName}/${personalObjective.line}.${personalObjective.subline}',
        body: payload);
    await fetchActiveTask();
  }

  Future<Task?> updateActiveTask(List<SubTask> subTasks) async {
    Task target = TasksService().snapActiveTask!;
    User user = AuthenticationService().authenticatedUser;
    Map<String, dynamic> payload = {
      "sub-tasks": subTasks.map((e) => e.toMap()).toList(),
      "description": target.personalObjective.rawObjective
    };
    await put('api/users/${user.id}/tasks/active', payload);
    return await fetchActiveTask();
  }

  Future<FullTask?> fetchActiveTask({bool onlyLogs = false}) async {
    String userId = AuthenticationService().authenticatedUserId;
    Task? task;
    List<Log> logs;
    try {
      if (onlyLogs) {
        task = snapActiveTask!;
      } else {
        Map<String, dynamic> response =
            await get('api/users/$userId/tasks/active');
        task = Task.fromMap(response);
      }
      logs = await LogsService().getProgressLogs(task);
    } on HttpError catch (e) {
      if (e.statusCode == 404) {
        task = null;
        logs = [];
      } else {
        rethrow;
      }
    }
    FullTask? fullTask =
        task != null ? FullTask.fromTask(task: task, logs: logs) : null;
    activeTaskSubject.add(fullTask);
    return fullTask;
  }

  BehaviorSubject<FullTask> _getTaskSubject(String userId,
      DevelopmentStage stage, DevelopmentArea area, int line, int subline) {
    Map<
            DevelopmentStage,
            Map<DevelopmentArea,
                Map<int, Map<int, BehaviorSubject<FullTask>>>>>? userMap =
        cache[userId];
    if (userMap == null) {
      userMap = cache[userId] = Map.fromEntries(
          DevelopmentStage.values.map((stage) => MapEntry(stage, {})));
    }
    Map<DevelopmentArea, Map<int, Map<int, BehaviorSubject<FullTask>>>>?
        stageMap = userMap[stage];
    if (stageMap == null) {
      stageMap = userMap[stage] = Map.fromEntries(
          DevelopmentArea.values.map((area) => MapEntry(area, {})));
    }
    Map<int, Map<int, BehaviorSubject<FullTask>>>? areaMap = stageMap[area];
    if (areaMap == null) {
      areaMap = stageMap[area] = {};
    }
    Map<int, BehaviorSubject<FullTask>>? lineMap = areaMap[line];
    if (lineMap == null) {
      lineMap = areaMap[line] = {};
    }
    BehaviorSubject<FullTask>? subject = lineMap[subline];
    if (subject == null) {
      subject = lineMap[subline] = new BehaviorSubject<FullTask>();
    }
    return subject;
  }

  Stream<FullTask> getTaskStream(String userId, DevelopmentStage stage,
      DevelopmentArea area, int line, int subline) {
    return _getTaskSubject(userId, stage, area, line, subline);
  }

  Future<FullTask?> fetchTask(String userId, DevelopmentStage stage,
      DevelopmentArea area, int line, int subline) async {
    FullTask? fullTask =
        await fetchFullTask(userId, stage, area, line, subline);
    if (fullTask != null) {
      _getTaskSubject(userId, stage, area, line, subline).add(fullTask);
    }
    return fullTask;
  }

  Future<FullTask?> fetchFullTask(String userId, DevelopmentStage stage,
      DevelopmentArea area, int line, int subline) async {
    Task? task = await fetchUserTask(userId, stage, area, line, subline);
    if (task != null) {
      List<Log> logs = await LogsService().getProgressLogs(task);
      return FullTask.fromTask(task: task, logs: logs);
    }
  }

  Future<List<Task>> getMyTasks() async {
    User user = AuthenticationService().authenticatedUser;
    try {
      Map<String, dynamic> response = await get('api/users/${user.id}/tasks/');
      List items = response["items"];
      List<Task> tasks = items.map((item) => Task.fromLiteMap(item)).toList();
      return tasks;
    } on HttpError {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Task>> getUserTasksByArea(
      User user, DevelopmentStage stage, DevelopmentArea area) async {
    try {
      Map<String, dynamic> response = await get(
          'api/users/${user.id}/tasks/${stageToString(stage)}/${areaToString(area)}/');
      List items = response["items"];
      List<Task> tasks = items.map((item) => Task.fromLiteMap(item)).toList();
      return tasks;
    } on HttpError {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  BehaviorSubject<List<Task>> _userTasksSubject = BehaviorSubject<List<Task>>();

  Stream<List<Task>> get userTasks => _userTasksSubject.stream;

  Future<Task?> fetchUserTask(String userId, DevelopmentStage stage,
      DevelopmentArea area, int line, int subline) async {
    Task? task;
    try {
      Map<String, dynamic> response = await get(
          'api/users/$userId/tasks/${stageToString(stage)}/${areaToString(area)}/$line.$subline');
      task = Task.fromMap(response);
    } on HttpError catch (e) {
      if (e.statusCode == 404) {
        task = null;
      } else {
        rethrow;
      }
    }
    return task;
  }

  Future<void> updateUserTasks() async {
    try {
      String userId = AuthenticationService().authenticatedUserId;
      Map<String, dynamic> response = await get('api/users/$userId/tasks/');
      List items = response["items"];
      _userTasksSubject.add(items.map((item) => Task.fromMap(item)).toList());
    } on HttpError {
      rethrow;
    } on SocketException {
      rethrow;
    }
  }

  void dispose() {
    activeTaskSubject.close();
    _userTasksSubject.close();
  }

  Future<CompleteTaskResponse> completeActiveTask() async {
    String userId = AuthenticationService().authenticatedUserId;
    Map<String, dynamic> data =
        await post('api/users/$userId/tasks/active/complete');
    await fetchActiveTask();
    CompleteTaskResponse response = CompleteTaskResponse.fromMap(data);
    await RewardsService().saveReward(response.reward);
    return response;
  }

  Future<void> initializeObjectives(
      Map<DevelopmentArea, List<Objective>> objectives) async {
    String userId = AuthenticationService().authenticatedUserId;
    Map<String, dynamic> response =
        await post('/api/users/$userId/tasks/initialize/', body: {
      'objectives': objectives.values
          .expand((element) => element)
          .map(
              (e) => {"line": e.line, "subline": e.subline, "area": e.areaName})
          .toList()
    });
    RewardToken token = RewardToken(response['reward']);
    RewardsService().saveReward(token);
    await AuthenticationService().updateAuthenticatedUser();
  }
}
