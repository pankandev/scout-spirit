// To parse this JSON data, do
//
//     final beneficiary = beneficiaryFromJson(jsonString);

import 'dart:convert';

import 'package:scout_spirit/src/utils/json.dart';

Beneficiary beneficiaryFromJson(String str) => Beneficiary.fromMap(json.decode(str));

String beneficiaryToJson(Beneficiary data) => json.encode(data.toJson());

class Beneficiary {
  Beneficiary({
    this.completed,
    this.unitUser,
    this.boughtItems,
    this.birthdate,
    this.nickname,
    this.target,
    this.nTasks,
    this.score,
    this.userId,
    this.fullName,
    this.groupCode,
    this.districtCode
  });

  dynamic completed;
  String unitUser;
  BoughtItems boughtItems;
  String birthdate;
  String nickname;
  dynamic target;
  TasksCount nTasks;
  TasksCount score;
  String userId;
  String fullName;
  String groupCode;
  String districtCode;

  factory Beneficiary.fromMap(Map<String, dynamic> json) => Beneficiary(
    completed: json["completed"],
    unitUser: json["unit-user"],
    boughtItems: BoughtItems.fromJson(json["bought_items"]),
    birthdate: json["birthdate"],
    nickname: json["nickname"],
    target: json["target"],
    nTasks: TasksCount.fromJson(json["n_tasks"]),
    score: TasksCount.fromJson(json["score"]),
    userId: json["user"],
    fullName: json["full-name"],
    groupCode: json["group"].split('::')[1],
    districtCode: json["group"].split('::')[0],
  );

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
  };

  @override
  String toString() {
    return "Beneficiary(fullName: '$fullName', nickname: '$nickname', userId: $userId, district: $districtCode, group: $groupCode)";
  }
}

class BoughtItems {
  BoughtItems();

  factory BoughtItems.fromJson(Map<String, dynamic> json) => BoughtItems(
  );

  Map<String, dynamic> toJson() => {
  };
}

class TasksCount {
  TasksCount({
    this.sociability,
    this.character,
    this.affectivity,
    this.creativity,
    this.spirituality,
    this.corporality,
  });

  int sociability;
  int character;
  int affectivity;
  int creativity;
  int spirituality;
  int corporality;

  factory TasksCount.fromJson(Map<String, dynamic> json) => json != null ? TasksCount(
    sociability: JsonUtils.to<int>(json["sociability"]),
    character: JsonUtils.to<int>(json["character"]),
    affectivity: JsonUtils.to<int>(json["affectivity"]),
    creativity: JsonUtils.to<int>(json["creativity"]),
    spirituality: JsonUtils.to<int>(json["spirituality"]),
    corporality: JsonUtils.to<int>(json["corporality"]),
  ) : TasksCount(sociability: 0, character: 0, affectivity: 0, creativity: 0, spirituality: 0, corporality: 0);

  Map<String, dynamic> toJson() => {
    "sociability": sociability,
    "character": character,
    "affectivity": affectivity,
    "creativity": creativity,
    "spirituality": spirituality,
    "corporality": corporality,
  };
}
