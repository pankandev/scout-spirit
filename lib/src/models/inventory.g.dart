// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemQuantityAdapter extends TypeAdapter<ItemQuantity> {
  @override
  final int typeId = 8;

  @override
  ItemQuantity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemQuantity(
      fields[0] as String,
      fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ItemQuantity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemQuantityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InventoryAdapter extends TypeAdapter<Inventory> {
  @override
  final int typeId = 7;

  @override
  Inventory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Inventory(
      hotbar: (fields[0] as List).cast<String?>(),
      items: (fields[1] as List).cast<ItemQuantity>(),
    );
  }

  @override
  void write(BinaryWriter writer, Inventory obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.hotbar)
      ..writeByte(1)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
