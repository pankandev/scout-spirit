import 'dart:convert';

import 'package:hive/hive.dart';

part 'world.g.dart';

World worldFromMap(String str) => World.fromMap(json.decode(str));

String worldToMap(World data) => json.encode(data.toMap());

@HiveType(typeId: 1)
class World {
  World({
    required this.zones,
    required this.currentZoneId,
    required this.currentNodeId,
  });

  @HiveField(0)
  Map<String, Zone> zones;

  @HiveField(1)
  String currentZoneId;

  @HiveField(2)
  String currentNodeId;

  factory World.fromMap(Map<String, dynamic> json) => World(
        zones: json.map((key, value) => MapEntry(key, Zone.fromMap(value))),
        currentZoneId: json["currentZoneId"],
        currentNodeId: json["currentNodeId"],
      );

  Map<String, dynamic> toMap() => {
        "zones": zones.map((key, value) => MapEntry(key, value.toMap())),
        "currentZoneId": currentZoneId,
        "currentNodeId": currentNodeId,
      };
}

@HiveType(typeId: 2)
class Zone {
  Zone({
    required this.zoneId,
    required this.objects,
    required this.lastJoinTime,
    required this.nodes,
  });

  @HiveField(0)
  String zoneId;

  @HiveField(1)
  List<ZoneObject> objects;

  @HiveField(2)
  int? lastJoinTime;

  @HiveField(3)
  Map<String, Node> nodes;

  factory Zone.fromMap(Map<String, dynamic> json) => Zone(
        zoneId: json["zoneId"],
        objects: List<ZoneObject>.from(
            json["objects"].map((x) => ZoneObject.fromMap(x))),
        lastJoinTime: json["lastJoinTime"],
        nodes: json["nodes"]
            .map((key, value) => MapEntry(key, Node.fromMap(value))),
      );

  Map<String, dynamic> toMap() => {
        "zoneId": zoneId,
        "objects":
            List<Map<String, dynamic>>.from(objects.map((x) => x.toMap())),
        "lastJoinTime": lastJoinTime,
        "nodes": nodes.map((key, value) => MapEntry(key, value.toMap())),
      };
}

@HiveType(typeId: 3)
class Node {
  Node({
    required this.zone,
    required this.node,
  });

  @HiveField(0)
  String zone;

  @HiveField(1)
  String node;

  factory Node.fromMap(Map<String, dynamic> json) => Node(
        zone: json["zone"],
        node: json["node"],
      );

  Map<String, dynamic> toMap() => {
        "zone": zone,
        "node": node,
      };
}

@HiveType(typeId: 4)
class ZoneObject {
  ZoneObject(
      {required this.objectId,
      required this.position,
      required this.rotation,
      required this.scale});

  @HiveField(0)
  final String objectId;

  @HiveField(1)
  final Vector3 position;

  @HiveField(2)
  final Quaternion rotation;

  @HiveField(3)
  final Vector3 scale;

  factory ZoneObject.fromMap(Map<String, dynamic> json) => ZoneObject(
      objectId: json["objectId"],
      position: Vector3.fromMap(json["position"]),
      rotation: Quaternion.fromMap(json["rotation"]),
      scale: Vector3.fromMap(json["scale"]));

  Map<String, dynamic> toMap() {
    return {
      "objectId": objectId,
      "position": position.toMap(),
      "rotation": rotation.toMap(),
      "scale": scale.toMap()
    };
  }
}

@HiveType(typeId: 5)
class Vector3 {
  Vector3({required this.x, required this.y, required this.z});

  @HiveField(0)
  final double x;

  @HiveField(1)
  final double y;

  @HiveField(2)
  final double z;

  factory Vector3.fromMap(Map<String, dynamic> json) =>
      Vector3(x: json["x"], y: json["y"], z: json["z"]);

  Map<String, dynamic> toMap() {
    return {
      "x": x,
      "y": y,
      "z": z,
    };
  }
}

@HiveType(typeId: 6)
class Quaternion {
  Quaternion(
      {required this.x, required this.y, required this.z, required this.w});

  @HiveField(0)
  final double x;

  @HiveField(1)
  final double y;

  @HiveField(2)
  final double z;

  @HiveField(3)
  final double w;

  factory Quaternion.fromMap(Map<String, dynamic> json) =>
      Quaternion(x: json["x"], y: json["y"], z: json["z"], w: json["w"]);

  Map<String, dynamic> toMap() {
    return {"x": x, "y": y, "z": z, "w": w};
  }
}
