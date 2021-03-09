// To parse this JSON data, do
//
//     final beneficiary = beneficiaryFromJson(jsonString);

import 'dart:convert';

import 'package:scout_spirit/src/utils/json.dart';

Beneficiary beneficiaryFromJson(String str) => Beneficiary.fromJson(json.decode(str));

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
    this.user,
    this.fullName,
    this.group,
  });

  dynamic completed;
  String unitUser;
  BoughtItems boughtItems;
  String birthdate;
  String nickname;
  dynamic target;
  TasksCount nTasks;
  TasksCount score;
  String user;
  String fullName;
  String group;

  factory Beneficiary.fromJson(Map<String, dynamic> json) => Beneficiary(
    completed: json["completed"],
    unitUser: json["unit-user"],
    boughtItems: BoughtItems.fromJson(json["bought_items"]),
    birthdate: json["birthdate"],
    nickname: json["nickname"],
    target: json["target"],
    nTasks: TasksCount.fromJson(json["n_tasks"]),
    score: TasksCount.fromJson(json["score"]),
    user: json["user"],
    fullName: json["full-name"],
    group: json["group"],
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
    "user": user,
    "full-name": fullName,
    "group": group,
  };

  @override
  String toString() {
    return "Beneficiary(full-name: '$fullName', nickname: '$nickname', user: $user, group: $group)";
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

  factory TasksCount.fromJson(Map<String, dynamic> json) => TasksCount(
    sociability: JsonUtils.to<int>(json["sociability"]),
    character: JsonUtils.to<int>(json["character"]),
    affectivity: JsonUtils.to<int>(json["affectivity"]),
    creativity: JsonUtils.to<int>(json["creativity"]),
    spirituality: JsonUtils.to<int>(json["spirituality"]),
    corporality: JsonUtils.to<int>(json["corporality"]),
  );

  Map<String, dynamic> toJson() => {
    "sociability": sociability,
    "character": character,
    "affectivity": affectivity,
    "creativity": creativity,
    "spirituality": spirituality,
    "corporality": corporality,
  };
}
