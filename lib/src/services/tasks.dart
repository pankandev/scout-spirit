import 'package:rxdart/rxdart.dart';
import 'package:scout_spirit/src/error/app_error.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/models/reward_token.dart';
import 'package:scout_spirit/src/models/task.dart';
import 'package:scout_spirit/src/models/user.dart';
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

class TasksService extends RestApiService {
  final BehaviorSubject<Task?> taskSubject = BehaviorSubject<Task>();

  Stream<Task?> get activeTask => taskSubject.stream;

  Task? get snapActiveTask => taskSubject.value;

  static TasksService _instance = TasksService._internal();

  TasksService._internal();

  factory TasksService() {
    return _instance;
  }

  Future<void> startObjective(
      Objective personalObjective, List<SubTask> tasks) async {
    if (tasks.length == 0) throw new AppError(message: 'Tasks list is empty');
    User user = AuthenticationService().snapAuthenticatedUser!;
    Map<String, dynamic> payload = {
      "sub-tasks": tasks.map((e) => e.description).toList(),
      "description": personalObjective.rawObjective
    };
    await post(
        'api/users/${user.id}/tasks/${user.stageName}/${personalObjective.areaName}/${personalObjective.line}.${personalObjective.subline}',
        body: payload);
    await getActiveTask();
  }

  Future<Task?> updateActiveTask(List<SubTask> subTasks) async {
    Task target = TasksService().snapActiveTask!;
    User user = AuthenticationService().snapAuthenticatedUser!;
    Map<String, dynamic> payload = {
      "sub-tasks": subTasks.map((e) => e.toMap()).toList(),
      "description": target.personalObjective.rawObjective
    };
    await put('api/users/${user.id}/tasks/active', payload);
    return await getActiveTask();
  }

  Future<Task?> getActiveTask() async {
    User user = AuthenticationService().snapAuthenticatedUser!;
    Task? task;
    try {
      Map<String, dynamic> response =
          await get('api/users/${user.id}/tasks/active');
      task = Task.fromMap(response);
    } on HttpError catch (e) {
      if (e.statusCode == 404) {
        task = null;
      } else {
        throw e;
      }
    }
    taskSubject.sink.add(task);
    return task;
  }

  Future<List<Task>> getUserTasksByArea(
      User user, DevelopmentStage stage, DevelopmentArea area) async {
    try {
      Map<String, dynamic> response = await get('api/users/${user.id}/tasks/${stageToString(stage)}/${areaToString(area)}/');
      List items = response["items"];
      List<Task> tasks = items.map((item) => Task.fromLiteMap(item)).toList();
      return tasks;
    } on HttpError catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

  Future<Task?> getUserTasksByStage(User user, DevelopmentStage stage) async {
    Task? task;
    try {
      Map<String, dynamic> response =
          await get('api/users/${user.id}/tasks/${stageToString(stage)}/');
      task = Task.fromMap(response);
    } on HttpError catch (e) {
      if (e.statusCode == 404) {
        task = null;
      } else {
        throw e;
      }
    }
    taskSubject.sink.add(task);
    return task;
  }

  Future<Task?> getUserTasks(User user) async {
    try {
      Map<String, dynamic> response = await get('api/users/${user.id}/tasks/');
      var items = response["items"];
      return items.map((item) => Task.fromMap(item)).toList();
    } on HttpError catch (e) {
      throw e;
    }
  }

  Future<Task?> getUserTask(User user, DevelopmentStage stage,
      DevelopmentArea area, int line, int subline) async {
    Task? task;
    try {
      Map<String, dynamic> response = await get(
          'api/users/${user.id}/tasks/${stageToString(stage)}/${areaToString(area)}/$line/$subline');
      task = Task.fromMap(response);
    } on HttpError catch (e) {
      if (e.statusCode == 404) {
        task = null;
      } else {
        throw e;
      }
    }
    taskSubject.sink.add(task);
    return task;
  }

  void dispose() {
    taskSubject.close();
  }

  Future<CompleteTaskResponse> completeActiveTask() async {
    User user = AuthenticationService().snapAuthenticatedUser!;
    Map<String, dynamic> data =
        await post('api/users/${user.id}/tasks/active/complete');
    await getActiveTask();
    CompleteTaskResponse response = CompleteTaskResponse.fromMap(data);
    await RewardsService().saveReward(response.reward);
    return response;
  }

  Future<void> initializeObjectives(
      Map<DevelopmentArea, List<Objective>> objectives) async {
    String userId = AuthenticationService().authenticatedUserId;
    Map<String, dynamic> response = await post('/api/users/$userId/tasks/initialize/', body: {
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
