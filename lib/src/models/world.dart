import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:scout_spirit/src/utils/json.dart';

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
        zones: json.map<String, Zone>(
            (key, value) => MapEntry<String, Zone>(key, Zone.fromMap(value))),
        currentZoneId: json["currentZoneId"],
        currentNodeId: json["currentNodeId"],
      );

  Map<String, dynamic> toMap() => {
        "zones": zones.map<String, Map<String, dynamic>>((key, value) =>
            MapEntry<String, Map<String, dynamic>>(key, value.toMap())),
        "currentZoneId": currentZoneId,
        "currentNodeId": currentNodeId,
      };
}

class NodeMeta {
  final String name;
  final String emoji;

  NodeMeta.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        emoji = map['emoji'];

  @override
  String toString() {
    return "NodeMeta(name: $name, emoji: $emoji)";
  }
}

class ZoneMeta {
  final Zone zone;

  final String name;
  final String emoji;

  final Map<String, NodeMeta> nodes;

  ZoneMeta.fromMap(Zone zone, Map<String, dynamic> map)
      : zone = zone,
        name = map['name'],
        emoji = map['emoji'],
        nodes = (map['nodes'] as Map)
            .cast<String, dynamic>()
            .map<String, NodeMeta>((key, value) => new MapEntry(
                key, NodeMeta.fromMap((value as Map).cast<String, dynamic>())));

  @override
  String toString() {
    return "ZoneMeta(name: $name, emoji: $emoji, nodes: $nodes, zone: $zone)";
  }
}

class ZoneConnection {
  final String nodeId;
  final Zone zone;

  const ZoneConnection({required this.nodeId, required this.zone});
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
  Map<String, Node?> nodes;

  factory Zone.fromMap(Map<String, dynamic> json) {
    Map nodes = json["nodes"];
    List objects = json["objects"];
    String zoneId = json["zoneId"];
    return Zone(
      zoneId: zoneId,
      objects: objects.map((x) => ZoneObject.fromMap(x)).toList(),
      lastJoinTime: json["lastJoinTime"],
      nodes: nodes.cast<String, dynamic>().map<String, Node?>((key, value) =>
          MapEntry<String, Node?>(
              key, value == null ? null : Node.fromMap(value))),
    );
  }

  Map<String, dynamic> toMap() => {
        "zoneId": zoneId,
        "objects": objects.map((x) => x.toMap()).toList(),
        "lastJoinTime": lastJoinTime,
        "nodes": nodes.cast<String, Node?>().map<String, Map<String, String>?>(
            (String key, Node? value) =>
                MapEntry<String, Map<String, String>?>(key, value?.toMap())),
      };

  @override
  String toString() {
    return toMap().toString();
  }
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

  Map<String, String> toMap() => {
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
      objectId: json["id"],
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
  Vector3(this.x, this.y, this.z);

  @HiveField(0)
  final double x;

  @HiveField(1)
  final double y;

  @HiveField(2)
  final double z;

  factory Vector3.fromMap(Map<String, dynamic> json) => Vector3(
      JsonUtils.to<double>(json["x"]!)!,
      JsonUtils.to<double>(json["y"]!)!,
      JsonUtils.to<double>(json["z"]!)!);

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
  Quaternion(this.x, this.y, this.z, this.w);

  @HiveField(0)
  final double x;

  @HiveField(1)
  final double y;

  @HiveField(2)
  final double z;

  @HiveField(3)
  final double w;

  factory Quaternion.fromMap(Map<String, dynamic> json) => Quaternion(
      JsonUtils.to<double>(json["x"]!)!,
      JsonUtils.to<double>(json["y"]!)!,
      JsonUtils.to<double>(json["z"]!)!,
      JsonUtils.to<double>(json["w"]!)!);

  Map<String, dynamic> toMap() {
    return {"x": x, "y": y, "z": z, "w": w};
  }
}
