import 'package:scout_spirit/src/error/app_error.dart';
import 'package:scout_spirit/src/models/log.dart';

enum RewardType { ZONE, AVATAR, POINTS, NEEDS, DECORATION }

RewardType rewardTypeFromName(String name) {
  switch (name.toUpperCase()) {
    case 'ZONE':
      return RewardType.ZONE;
    case 'AVATAR':
      return RewardType.AVATAR;
    case 'POINTS':
      return RewardType.POINTS;
    case 'DECORATION':
      return RewardType.DECORATION;
    case 'NEEDS':
      return RewardType.NEEDS;
  }
  throw new AppError(message: 'Unknown reward type: $name');
}

abstract class Reward {
  final int? id;
  final int? release;
  final RewardType category;

  const Reward(this.category, {this.id, this.release});

  factory Reward.fromMap(Map<String, dynamic> map) {
    RewardType type = rewardTypeFromName(map["category"]);
    int? id = map["id"]?.round();
    int? release = map["release"]?.round();
    Map<String, dynamic> description = map["description"];

    switch (type) {
      case RewardType.ZONE:
        return ZoneReward.fromMap(description, id: id, release: release);
      case RewardType.AVATAR:
        return AvatarPart.fromMap(description, id: id, release: release);
      case RewardType.POINTS:
        return Points.fromMap(description, id: id, release: release);
      case RewardType.NEEDS:
        return Needs.fromMap(description, id: id, release: release);
      case RewardType.DECORATION:
        return DecorationReward.fromMap(description, id: id, release: release);
    }
  }

  factory Reward.fromLog(Log log) {
    return Reward.fromMap(log.data!);
  }

  @override
  String toString() {
    return "Reward(type: $category)";
  }
}

class ZoneReward extends Reward {
  final String zoneId;

  ZoneReward.fromMap(Map<String, dynamic> map,
      {int? timestamp, int? id, int? release})
      : zoneId = map["code"]!,
        super(RewardType.ZONE, id: id, release: release);

  @override
  String toString() {
    return "Zone(code: $zoneId)";
  }
}

class DecorationReward extends Reward {
  final String code;
  final String type;

  DecorationReward.fromMap(Map<String, dynamic> map,
      {int? timestamp, int? id, int? release})
      : code = map["code"]!,
        type = map["type"]!,
        super(RewardType.DECORATION, id: id, release: release);

  DecorationReward.dummyFromCode(String code)
      : code = code,
        type = 'DUMMY',
        super(RewardType.DECORATION, id: 0, release: 0);

  @override
  String toString() {
    return "Decoration(code: $code, type: $type)";
  }
}

class Needs extends Reward {
  final int hunger;
  final int thirst;

  Needs.fromMap(Map<String, dynamic> map,
      {int? timestamp, int? id, int? release})
      : hunger = map["hunger"]!,
        thirst = map["thirst"]!,
        super(RewardType.NEEDS, id: id, release: release);

  @override
  String toString() {
    return "Needs(hunger: $hunger, thirst: $thirst)";
  }
}

class Points extends Reward {
  final int amount;

  Points.fromMap(Map<String, dynamic> map,
      {int? timestamp, int? id, int? release})
      : amount = map["amount"]!,
        super(RewardType.POINTS, id: id, release: release);

  @override
  String toString() {
    return "Points(amount: $amount)";
  }
}

enum AvatarRewardType { PANTS, SHIRT, EYE, MOUTH, NECKERCHIEF }

abstract class AvatarPart extends Reward {
  final AvatarRewardType type;

  AvatarPart({required this.type, int? timestamp, int? id, int? release})
      : super(RewardType.AVATAR, id: id, release: release);

  Map<String, dynamic> attributesToMap();

  bool compareWith(AvatarPart? part);

  Map<String, dynamic> toMap() {
    return {"type": typeToName(type), "description": attributesToMap()};
  }

  factory AvatarPart.fromMap(Map<String, dynamic> map,
      {int? timestamp, int? id, int? release}) {
    Map<String, dynamic> innerDescription = map["description"];
    switch (typeFromName(map["type"])) {
      case AvatarRewardType.PANTS:
        return AvatarPants.fromMap(innerDescription,
            timestamp: timestamp, id: id, release: release);
      case AvatarRewardType.SHIRT:
        return AvatarShirt.fromMap(innerDescription,
            timestamp: timestamp, id: id, release: release);
      case AvatarRewardType.EYE:
        return AvatarEye.fromMap(innerDescription,
            timestamp: timestamp, id: id, release: release);
      case AvatarRewardType.MOUTH:
        return AvatarMouth.fromMap(innerDescription,
            timestamp: timestamp, id: id, release: release);
      case AvatarRewardType.NECKERCHIEF:
        return AvatarNeckerchief.fromMap(innerDescription,
            timestamp: timestamp, id: id, release: release);
    }
  }

  static AvatarRewardType typeFromName(String type) {
    switch (type.toLowerCase()) {
      case "mouth":
        return AvatarRewardType.MOUTH;
      case "eye":
        return AvatarRewardType.EYE;
      case "pants":
        return AvatarRewardType.PANTS;
      case "shirt":
        return AvatarRewardType.SHIRT;
    }
    throw new AppError(message: "Unknown avatar reward type: $type");
  }

  static String typeToName(AvatarRewardType type) {
    return type.toString().split('.')[1].toLowerCase();
  }

  @override
  String toString() {
    return "AvatarPart(type: ${typeToName(type)}, attributes: ${attributesToMap()}, id: $id, release: $release)";
  }

  @override
  bool operator ==(Object other) {
    if (other is AvatarPart && runtimeType == other.runtimeType) {
      return this.compareWith(other);
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode;
}

enum AvatarShirtType { COMMON, SHIRT, TSHIRT }

class AvatarShirt extends AvatarPart {
  final AvatarShirtType shirtType;
  final String material;

  AvatarShirt({required this.shirtType, required this.material})
      : super(type: AvatarRewardType.SHIRT);

  @override
  Map<String, dynamic> attributesToMap() {
    return {"material": material, "type": shirtTypeToName(shirtType)};
  }

  static String shirtTypeToName(AvatarShirtType type) {
    return type.toString().split('.')[1].toLowerCase();
  }

  static AvatarShirtType shirtTypeFromName(String name) {
    switch (name.toLowerCase()) {
      case "common":
        return AvatarShirtType.COMMON;
      case "shirt":
        return AvatarShirtType.SHIRT;
      case "t-shirt":
        return AvatarShirtType.TSHIRT;
    }
    throw new AppError(message: "Unknown shirt type: $name");
  }

  AvatarShirt.fromMap(Map<String, dynamic> map,
      {int? timestamp, int? id, int? release})
      : material = map["material"],
        shirtType = shirtTypeFromName(map["type"]),
        super(
            type: AvatarRewardType.SHIRT,
            timestamp: timestamp,
            id: id,
            release: release);

  @override
  bool compareWith(AvatarPart? part) {
    if (part is AvatarShirt) {
      return part.material == material && part.shirtType == shirtType;
    }
    return false;
  }
}

class AvatarPants extends AvatarPart {
  final String material;

  AvatarPants({required this.material}) : super(type: AvatarRewardType.PANTS);

  @override
  Map<String, dynamic> attributesToMap() {
    return {
      "material": material,
    };
  }

  AvatarPants.fromMap(Map<String, dynamic> map,
      {int? timestamp, int? id, int? release})
      : material = map["material"],
        super(
            type: AvatarRewardType.PANTS,
            timestamp: timestamp,
            id: id,
            release: release);

  @override
  bool compareWith(AvatarPart? part) {
    if (part is AvatarPants) {
      return part.material == material;
    }
    return false;
  }
}

class AvatarEye extends AvatarPart {
  final String material;

  AvatarEye({required this.material}) : super(type: AvatarRewardType.EYE);

  Map<String, dynamic> attributesToMap() {
    return {
      "material": material,
    };
  }

  AvatarEye.fromMap(Map<String, dynamic> descriptionMap,
      {int? timestamp, int? id, int? release})
      : material = descriptionMap["material"],
        super(
            type: AvatarRewardType.EYE,
            timestamp: timestamp,
            id: id,
            release: release);

  @override
  bool compareWith(AvatarPart? part) {
    if (part is AvatarEye) {
      return part.material == material;
    }
    return false;
  }
}

class AvatarMouth extends AvatarPart {
  final String material;

  AvatarMouth({required this.material}) : super(type: AvatarRewardType.MOUTH);

  Map<String, dynamic> attributesToMap() {
    return {
      "material": material,
    };
  }

  AvatarMouth.fromMap(Map<String, dynamic> descriptionMap,
      {int? timestamp, int? id, int? release})
      : material = descriptionMap["material"],
        super(
            type: AvatarRewardType.MOUTH,
            timestamp: timestamp,
            id: id,
            release: release);

  @override
  bool compareWith(AvatarPart? part) {
    if (part is AvatarMouth) {
      return part.material == material;
    }
    return false;
  }
}

class AvatarNeckerchief extends AvatarPart {
  final String material;

  AvatarNeckerchief({required this.material, int? timestamp})
      : super(type: AvatarRewardType.MOUTH, timestamp: timestamp);

  Map<String, dynamic> attributesToMap() {
    return {
      "material": material,
    };
  }

  AvatarNeckerchief.fromMap(Map<String, dynamic> descriptionMap,
      {int? timestamp, int? id, int? release})
      : material = descriptionMap["material"],
        super(
            type: AvatarRewardType.NECKERCHIEF,
            timestamp: timestamp,
            id: id,
            release: release);

  @override
  bool compareWith(AvatarPart? part) {
    if (part is AvatarNeckerchief) {
      return part.material == material;
    }
    return false;
  }
}
