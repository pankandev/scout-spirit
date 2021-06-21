import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scout_spirit/src/error/app_error.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/reward_token.dart';
import 'package:scout_spirit/src/models/log.dart';
import 'package:scout_spirit/src/providers/reward_provider.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/rest_api.dart';
import 'package:scout_spirit/src/services/rewards.dart';
import 'package:scout_spirit/src/services/tasks.dart';
import 'package:scout_spirit/src/utils/key.dart';

final Map<String, List<Map<String, dynamic>>> testLogs = {
  "REWARD::DECORATION": [
    {
      "tag": "REWARD::DECORATION",
      "timestamp": 1000,
      "log": "Won a reward!",
      "data": {
        "description": {"type": "Wood", "code": "box"},
        "category": 'DECORATION',
        "rarity": "COMMON",
        "release-id": 1
      },
    }
  ],
  "REWARD::AVATAR": [
    {
      "tag": "REWARD::AVATAR",
      "timestamp": 1000,
      "log": "Won a reward!",
      "data": {
        "description": {
          "type": "pants",
          "description": {"material": "red"}
        },
        "category": 'AVATAR',
        "rarity": "COMMON",
        "release-id": 1
      }
    },
    {
      "tag": "REWARD::AVATAR",
      "log": "Won a reward!",
      "timestamp": 1000,
      "data": {
        "description": {
          "type": "pants",
          "description": {"material": "blue"}
        },
        "category": 'AVATAR',
        "rarity": "COMMON",
        "release-id": 1
      }
    },
    {
      "tag": "REWARD::AVATAR",
      "log": "Won a reward!",
      "timestamp": 1000,
      "data": {
        "description": {
          "type": "pants",
          "description": {"material": "green"}
        },
        "category": 'AVATAR',
        "rarity": "COMMON",
        "release-id": 1
      }
    },
    {
      "tag": "REWARD::AVATAR",
      "log": "Won a reward!",
      "timestamp": 1000,
      "data": {
        "description": {
          "type": "eye",
          "description": {"material": "^"}
        },
        "category": 'AVATAR',
        "rarity": "COMMON",
        "release-id": 1
      }
    },
    {
      "tag": "REWARD::AVATAR",
      "log": "Won a reward!",
      "timestamp": 1000,
      "data": {
        "description": {
          "type": "eye",
          "description": {"material": "u"}
        },
        "category": 'AVATAR',
        "rarity": "COMMON",
        "release-id": 1
      }
    },
    {
      "tag": "REWARD::AVATAR",
      "log": "Won a reward!",
      "timestamp": 1000,
      "data": {
        "description": {
          "type": "shirt",
          "description": {
            "type": "shirt",
            "material": "cuadrille-red"
          }
        },
        "category": 'AVATAR',
        "rarity": "COMMON",
        "release-id": 1
      }
    },
    {
      "tag": "REWARD::AVATAR",
      "log": "Won a reward!",
      "timestamp": 1000,
      "data": {
        "description": {
          "type": "shirt",
          "description": {
            "type": "shirt",
            "material": "red"
          }
        },
        "category": 'AVATAR',
        "rarity": "COMMON",
        "release-id": 1
      }
    },
    {
      "tag": "REWARD::AVATAR",
      "log": "Won a reward!",
      "timestamp": 1000,
      "data": {
        "description": {
          "type": "shirt",
          "description": {
            "type": "shirt",
            "material": "dotted-blue"
          }
        },
        "category": 'AVATAR',
        "rarity": "COMMON",
        "release-id": 1
      }
    },
    {
      "tag": "REWARD::AVATAR",
      "log": "Won a reward!",
      "timestamp": 1000,
      "data": {
        "description": {
          "type": "shirt",
          "description": {
            "type": "t-shirt",
            "material": "fleur-violet"
          }
        },
        "category": 'AVATAR',
        "rarity": "COMMON",
        "release-id": 1
      }
    }
  ]
};

class LogsService extends RestApiService {
  static final LogsService _instance = LogsService._internal();

  factory LogsService() {
    return _instance;
  }

  LogsService._internal();

  Future<void> postProgressLog(BuildContext context, TaskToken token, String log,
      {dynamic? data}) async {
    Map<String, dynamic> body = {'log': log, 'token': token.token};
    if (data != null) {
      body['data'] = data;
    }
    String userId = AuthenticationService().snapAuthenticatedUser!.id;
    Map<String, dynamic> response;
    try {
      print(body);
      response =
          await this.post('/api/users/$userId/logs/PROGRESS/', body: body);
    } on HttpError catch (e, s) {
      print(s);
      throw e;
    }
    String? encodedToken = response['token'];
    if (encodedToken != null) {
      RewardToken token = RewardToken(encodedToken);
      await RewardsService().saveReward(token);
      await RewardChecker().checkForRewards(context);
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
    Map<String, dynamic> response;
    try {
      response = await this.get('/api/users/$userId/logs/$category/');
    } on SocketException catch (e, s) {
      if (!kReleaseMode) {
        response = {"items": testLogs[category.toUpperCase()] ?? []};
      } else {
        print(s);
        throw e;
      }
    }
    List<Map<String, dynamic>> items = List.from(response["items"]);
    return items.map((e) => Log.fromMap(e)).toList();
  }

  Future<List<Log>> getMyLogs() async {
    String userId = AuthenticationService().authenticatedUserId;
    Map<String, dynamic> response;
    try {
      response = await this.get('/api/users/$userId/logs/');
    } on SocketException catch (e, s) {
      if (!kReleaseMode) {
        response = {"items": testLogs.values.expand((element) => element)};
      } else {
        print(s);
        throw e;
      }
    }
    List<Map<String, dynamic>> items = List.from(response["items"]);
    return items.map((e) => Log.fromMap(e)).toList();
  }
}
