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

class CompleteTaskResponse {
  RewardToken reward;
  Task task;

  CompleteTaskResponse.fromMap(Map<String, dynamic> map):
    reward = RewardToken(map["reward"]),
    task = Task.fromMap(map["task"]);
}

class TasksService extends RestApiService {
  final BehaviorSubject<Task?> taskSubject = BehaviorSubject<Task>();

  Stream<Task?> get activeTask => taskSubject.stream;

  static TasksService _instance = TasksService._internal();

  TasksService._internal();

  factory TasksService() {
    return _instance;
  }

  Future<void> startObjective(
      Objective personalObjective, List<SubTask> tasks) async {
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
    User user = AuthenticationService().snapAuthenticatedUser!;
    Objective objective = user.beneficiary!.target!.personalObjective;
    Map<String, dynamic> payload = {
      "sub-tasks": subTasks.map((e) => e.toMap()).toList(),
      "description": objective.rawObjective
    };
    await put('api/users/${user.id}/tasks/active', payload);
    return await getActiveTask();
  }

  Future<Task?> getActiveTask() async {
    User user = AuthenticationService().snapAuthenticatedUser!;
    Task? task;
    try {
      Map<String, dynamic> response = await get('api/users/${user.id}/tasks/active');
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
    Map<String, dynamic> data = await post('api/users/${user.id}/tasks/active/complete');
    await getActiveTask();
    CompleteTaskResponse response = CompleteTaskResponse.fromMap(data);
    RewardsService().saveReward(response.reward);
    return response;
  }
}
