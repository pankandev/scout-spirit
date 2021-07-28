// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'world.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorldAdapter extends TypeAdapter<World> {
  @override
  final int typeId = 1;

  @override
  World read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return World(
      zones: (fields[0] as Map).cast<String, Zone>(),
      currentZoneId: fields[1] as String,
      currentNodeId: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, World obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.zones)
      ..writeByte(1)
      ..write(obj.currentZoneId)
      ..writeByte(2)
      ..write(obj.currentNodeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorldAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ZoneAdapter extends TypeAdapter<Zone> {
  @override
  final int typeId = 2;

  @override
  Zone read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Zone(
      zoneId: fields[0] as String,
      objects: (fields[1] as List).cast<ZoneObject>(),
      lastJoinTime: fields[2] as int?,
      nodes: (fields[3] as Map).cast<String, Node?>(),
    );
  }

  @override
  void write(BinaryWriter writer, Zone obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.zoneId)
      ..writeByte(1)
      ..write(obj.objects)
      ..writeByte(2)
      ..write(obj.lastJoinTime)
      ..writeByte(3)
      ..write(obj.nodes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZoneAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NodeAdapter extends TypeAdapter<Node> {
  @override
  final int typeId = 3;

  @override
  Node read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Node(
      zone: fields[0] as String,
      node: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Node obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.zone)
      ..writeByte(1)
      ..write(obj.node);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ZoneObjectAdapter extends TypeAdapter<ZoneObject> {
  @override
  final int typeId = 4;

  @override
  ZoneObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ZoneObject(
      objectId: fields[0] as String,
      position: fields[1] as Vector3,
      rotation: fields[2] as Quaternion,
      scale: fields[3] as Vector3,
    );
  }

  @override
  void write(BinaryWriter writer, ZoneObject obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.objectId)
      ..writeByte(1)
      ..write(obj.position)
      ..writeByte(2)
      ..write(obj.rotation)
      ..writeByte(3)
      ..write(obj.scale);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZoneObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class Vector3Adapter extends TypeAdapter<Vector3> {
  @override
  final int typeId = 5;

  @override
  Vector3 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vector3(
      fields[0] as double,
      fields[1] as double,
      fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Vector3 obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.x)
      ..writeByte(1)
      ..write(obj.y)
      ..writeByte(2)
      ..write(obj.z);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vector3Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuaternionAdapter extends TypeAdapter<Quaternion> {
  @override
  final int typeId = 6;

  @override
  Quaternion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quaternion(
      fields[0] as double,
      fields[1] as double,
      fields[2] as double,
      fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Quaternion obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.x)
      ..writeByte(1)
      ..write(obj.y)
      ..writeByte(2)
      ..write(obj.z)
      ..writeByte(3)
      ..write(obj.w);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuaternionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
