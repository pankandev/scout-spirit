// To parse this JSON data, do
//
//     final beneficiary = beneficiaryFromJson(jsonString);

import 'dart:convert';

import 'package:jose/jose.dart';
import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/models/task.dart';
import 'package:scout_spirit/src/services/objectives.dart';
import 'package:scout_spirit/src/utils/json.dart';

Beneficiary beneficiaryFromJson(String str) =>
    Beneficiary.fromMap(json.decode(str));

String beneficiaryToJson(Beneficiary data) => json.encode(data.toJson());

class TaskToken {
  final String token;
  final String sub;
  final int iat;
  final int exp;
  final Objective objective;

  bool get isExpired {
    DateTime expires =
        DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
    DateTime now = DateTime.now().toUtc();
    return now.isAfter(expires);
  }

  TaskToken._fromTokenPayload(this.token, Map<String, dynamic> payload)
      : sub = payload['sub'],
        iat = payload['iat'],
        exp = payload['exp'],
        objective = ObjectivesService().getByKey(payload['objective']);

  factory TaskToken(String encodedToken) {
    Map<String, dynamic> payload = json.decode(
        JsonWebSignature.fromCompactSerialization(encodedToken)
            .unverifiedPayload
            .stringContent);
    return TaskToken._fromTokenPayload(encodedToken, payload);
  }

  @override
  String toString() {
    return "RewardToken(sub: $sub, iat: $iat, exp: $exp, objective: $objective)";
  }
}

class Task {
  double score;
  DateTime? created;
  bool? completed;
  Objective originalObjective;
  Objective personalObjective;
  List<SubTask> tasks;
  bool? eligibleForReward;
  TaskToken? token;

  Task({
    required this.score,
    required this.originalObjective,
    required this.personalObjective,
    required this.tasks,
    this.created,
    this.completed,
  });

  Task.fromMap(Map<String, dynamic> map)
      : score = map['score'],
        tasks = List.from(map['tasks'].map((task) => SubTask(
            description: task['description'], completed: task['completed']))),
        personalObjective = Objective.fromCode(map['objective'])
            .copyWith(objective: map['personal-objective']),
        originalObjective = Objective.fromCode(map['objective'])
            .copyWith(objective: map['original-objective']),
        eligibleForReward = map['eligible_for_progress_reward'],
        token = map.containsKey('token') ? TaskToken(map['token']) : null,
        completed = map['completed'];

  Task.fromLiteMap(Map<String, dynamic> map)
      : score = 0,
        tasks = List.from(map['tasks'].map((task) => SubTask(
            description: task['description'], completed: task['completed']))),
        personalObjective = Objective.fromCode(map['objective'])
            .copyWith(objective: map['personal-objective']),
        originalObjective = Objective.fromCode(map['objective'])
            .copyWith(objective: map['original-objective']),
        eligibleForReward = false,
        token = null,
        completed = map['completed'];

  @override
  String toString() {
    return "Task(score: $score, created: $created, completed: $completed, originalObjective: $originalObjective, personalObjective: $personalObjective, tasks: $tasks, token: $token)";
  }
}

class Beneficiary {
  Beneficiary(
      {this.completed,
      required this.lastClaimedToken,
      required this.unitUser,
      required this.boughtItems,
      required this.birthdate,
      required this.nickname,
      required this.target,
      required this.nTasks,
      required this.score,
      required this.userId,
      required this.fullName,
      required this.groupCode,
      required this.districtCode,
      this.setBaseTasks});

  dynamic completed;
  String unitUser;
  BoughtItems boughtItems;
  bool? setBaseTasks;
  String birthdate;
  String nickname;
  Task? target;
  TasksCount nTasks;
  TasksCount score;
  String userId;
  String fullName;
  String groupCode;
  String districtCode;
  int lastClaimedToken;

  factory Beneficiary.fromMap(Map<String, dynamic> json) {
    return Beneficiary(
        completed: json["completed"],
        unitUser: json["unit-user"],
        boughtItems: BoughtItems.fromJson(json["bought_items"]),
        birthdate: json["birthdate"],
        nickname: json["nickname"],
        target: json["target"] != null ? Task.fromMap(json["target"]) : null,
        nTasks: TasksCount.fromJson(json["n_tasks"]),
        score: TasksCount.fromJson(json["score"]),
        userId: json["user"],
        fullName: json["full-name"],
        groupCode: json["group"],
        districtCode: json["district"],
        lastClaimedToken: json["last_claimed_token"],
        setBaseTasks: json["set_base_tasks"]);
  }

  Map<String, dynamic> toJson() => {
        "completed": completed,
        "unit-user": unitUser,
        "bought_items": boughtItems.toJson(),
        "birthdate": birthdate,
        "nickname": nickname,
        "target": target,
        "n_tasks": nTasks.toJson(),
        "score": score.toJson(),
        "user": userId,
        "full-name": fullName,
        "group": "$districtCode::$groupCode",
        "set_base_tasks": setBaseTasks
      };

  @override
  String toString() {
    return "Beneficiary(fullName: '$fullName', nickname: '$nickname', userId: $userId, district: $districtCode, group: $groupCode)";
  }
}

class BoughtItems {
  BoughtItems();

  factory BoughtItems.fromJson(Map<String, dynamic> json) => BoughtItems();

  Map<String, dynamic> toJson() => {};
}

class TasksCount {
  TasksCount({
    required this.sociability,
    required this.character,
    required this.affectivity,
    required this.creativity,
    required this.spirituality,
    required this.corporality,
  });

  int sociability;
  int character;
  int affectivity;
  int creativity;
  int spirituality;
  int corporality;

  factory TasksCount.fromJson(Map<String, dynamic>? json) => json != null
      ? TasksCount(
          sociability: JsonUtils.to<int>(json["sociability"])!,
          character: JsonUtils.to<int>(json["character"])!,
          affectivity: JsonUtils.to<int>(json["affectivity"])!,
          creativity: JsonUtils.to<int>(json["creativity"])!,
          spirituality: JsonUtils.to<int>(json["spirituality"])!,
          corporality: JsonUtils.to<int>(json["corporality"])!,
        )
      : TasksCount(
          sociability: 0,
          character: 0,
          affectivity: 0,
          creativity: 0,
          spirituality: 0,
          corporality: 0);

  Map<String, dynamic> toJson() => {
        "sociability": sociability,
        "character": character,
        "affectivity": affectivity,
        "creativity": creativity,
        "spirituality": spirituality,
        "corporality": corporality,
      };
}
