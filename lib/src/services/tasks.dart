import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/models/task.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/services/rest_api.dart';
import 'package:scout_spirit/src/services/authentication.dart';

class TasksService extends RestApiService {
  final String _apiPath = 'api/tasks';

  static TasksService _instance = TasksService._internal();

  TasksService._internal();

  factory TasksService() {
    return _instance;
  }

  Future<void> startObjective(
      Objective personalObjective, List<Task> tasks) async {
    User user = AuthenticationService().snapAuthenticatedUser;
    Map<String, dynamic> payload = {
      "sub-tasks": tasks.map((e) => e.description).toList(),
      "description": personalObjective.rawObjective
    };
    await post(
        'api/users/${user.id}/tasks/${user.stageName}/${personalObjective.areaName}/${personalObjective.line}.${personalObjective.subline}',
        payload);
  }
}
