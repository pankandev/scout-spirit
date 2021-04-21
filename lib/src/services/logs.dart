import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/reward_token.dart';
import 'package:scout_spirit/src/models/log.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/rest_api.dart';
import 'package:scout_spirit/src/services/rewards.dart';
import 'package:scout_spirit/src/services/tasks.dart';
import 'package:scout_spirit/src/utils/key.dart';

class LogsService extends RestApiService {
  static final LogsService _instance = LogsService._internal();

  factory LogsService() {
    return _instance;
  }

  LogsService._internal();

  Future<void> postProgressLog(Task task, String log, {dynamic? data}) async {
    Map<String, dynamic> body = {
      'token': task.token?.token,
      'log': log,
    };
    if (data != null) {
      body['data'] = data;
    }
    String userId = AuthenticationService().snapAuthenticatedUser!.id;
    Map<String, dynamic> response =
        await this.post('/api/users/$userId/logs/PROGRESS/', body: body);
    String? encodedToken = response['token'];
    if (encodedToken != null) {
      RewardToken token = RewardToken(encodedToken);
      await RewardsService().saveReward(token);
    }
  }

  Future<List<Log>> getProgressLogs(Task task) async {
    String category = joinKey([
      "PROGRESS",
      task.originalObjective.stageName,
      task.originalObjective.areaName,
      "${task.originalObjective.line}.${task.originalObjective.subline}"
    ]);
    return await getByCategory(category);
  }

  Future<List<Log>> getProgressLogsForActiveTask() async {
    Task task = TasksService().snapActiveTask!;
    return await getProgressLogs(task);
  }

  Future<List<Log>> getByCategory(String category) async {
    String userId = AuthenticationService().authenticatedUserId;
    Map<String, dynamic> response =
      await this.get('/api/users/$userId/logs/$category/');
    List<Map<String, dynamic>> items = List.from(response["items"]);
    return items.map((e) => Log.fromMap(e)).toList();
  }
}
