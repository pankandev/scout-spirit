// To parse this JSON data, do
//
//     final beneficiary = beneficiaryFromJson(jsonString);

import 'dart:math' as math;
import 'dart:convert';

import 'package:jose/jose.dart';
import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/models/task.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/services/objectives.dart';
import 'package:scout_spirit/src/utils/development_area.dart';
import 'package:scout_spirit/src/utils/development_stage.dart';
import 'package:scout_spirit/src/utils/json.dart';

import 'log.dart';

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

  DevelopmentStage get stage => originalObjective.stage;
  DevelopmentArea get area => originalObjective.area;
  int get line => originalObjective.line;
  int get subline => originalObjective.subline;

  ObjectiveKey get key => originalObjective;

  Task({
    required this.score,
    required this.originalObjective,
    required this.personalObjective,
    required this.tasks,
    this.token,
    this.created,
    this.completed,
  });

  Task.fromMap(Map<String, dynamic> map)
      : score = map['score'] ?? 0,
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
      required this.unit,
      required this.boughtItems,
      required this.birthdate,
      required this.nickname,
      required this.target,
      required this.profilePicture,
      required this.nTasks,
      required this.score,
      required this.userId,
      required this.fullName,
      required this.groupCode,
      required this.districtCode,
      this.setBaseTasks});

  dynamic completed;
  Unit unit;
  String? profilePicture;
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
        unit: unitFromName(json["unit"]),
        profilePicture: json["profile_picture"],
        boughtItems: BoughtItems.fromJson(json["bought_items"]),
        birthdate: json["birthdate"],
        nickname: json["nickname"],
        target: json["target"] != null ? Task.fromMap(json["target"]) : null,
        nTasks: TasksCount.fromJson(json["n_tasks"]),
        score: TasksCount.fromJson(json["score"]),
        userId: json["id"],
        fullName: json["full-name"],
        groupCode: json["group"],
        districtCode: json["district"],
        lastClaimedToken: json["last_claimed_token"],
        setBaseTasks: json["set_base_tasks"]);
  }

  int get totalScore => score.total;

  int get totalTasks => nTasks.total;

  Map<String, dynamic> toJson() => {
        "completed": completed,
        "unit": unit,
        "bought_items": boughtItems.toJson(),
        "birthdate": birthdate,
        "nickname": nickname,
        "target": target,
        "n_tasks": nTasks.toJson(),
        "score": score.toJson(),
        "id": userId,
        "profile_picture": profilePicture,
        "full-name": fullName,
        "group": "$districtCode::$groupCode",
        "set_base_tasks": setBaseTasks
      };

  @override
  String toString() {
    return "Beneficiary(fullName: '$fullName', nickname: '$nickname', userId: $userId, district: $districtCode, group: $groupCode)";
  }
}

class FullTask extends Task {
  final List<Log> logs;

  FullTask.fromTask({required Task task, required this.logs}):
      super(score: task.score,
        originalObjective: task.originalObjective,
        personalObjective: task.personalObjective,
        tasks: task.tasks,
        token: task.token,
        created: task.created,
        completed: task.completed);
}

class BoughtItems {
  BoughtItems();

  factory BoughtItems.fromJson(Map<String, dynamic> json) => BoughtItems();

  Map<String, dynamic> toJson() => {};
}

class AreaItem {
  final DevelopmentArea area;
  final int value;

  AreaItem({required this.area, required this.value});
}

class TasksCount {
  TasksCount({
    this.sociability = 0,
    this.character = 0,
    this.affectivity = 0,
    this.creativity = 0,
    this.spirituality = 0,
    this.corporality = 0,
  });

  int sociability;
  int character;
  int affectivity;
  int creativity;
  int spirituality;
  int corporality;

  int get total {
    return sociability +
        character +
        affectivity +
        creativity +
        spirituality +
        corporality;
  }

  List<AreaItem> get items {
    return [
      AreaItem(area: DevelopmentArea.Corporality, value: corporality),
      AreaItem(area: DevelopmentArea.Creativity, value: creativity),
      AreaItem(area: DevelopmentArea.Character, value: character),
      AreaItem(area: DevelopmentArea.Affectivity, value: affectivity),
      AreaItem(area: DevelopmentArea.Sociability, value: sociability),
      AreaItem(area: DevelopmentArea.Spirituality, value: spirituality),
    ];
  }

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

  double get integrityFactor {
    int max = values.fold<int>(
        0, (previousValue, element) => math.max(previousValue, element));
    List<double> normalized = values.map((e) => e / max).toList();
    double internalArea =
        normalized.asMap().keys.fold<double>(0.0, (double prev, int index) {
      // calculate area of each triangle inside radar chart
      double a = normalized[index];
      double b = normalized[(index + 1) % normalized.length];
      double area = 0.5 * a * b * math.sin(2 * math.pi / normalized.length);
      return prev + area;
    });
    double fullArea =
        0.5 * math.sin(2 * math.pi / normalized.length) * normalized.length;
    return internalArea / fullArea * 100;
  }

  List<int> get values => [
        corporality,
        affectivity,
        creativity,
        character,
        sociability,
        spirituality
      ];
}
