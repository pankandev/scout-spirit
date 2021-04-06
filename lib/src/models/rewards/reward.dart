import 'package:scout_spirit/src/error/app_error.dart';

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
  final RewardType category;

  const Reward(this.category);

  factory Reward.fromMap(Map<String, dynamic> map) {
    RewardType type = rewardTypeFromName(map["category"]);
    switch (type) {
      case RewardType.ZONE:
        return Zone.fromMap(map["description"]);
      case RewardType.AVATAR:
        return Avatar.fromMap(map["description"]);
      case RewardType.POINTS:
        return Points.fromMap(map["description"]);
      case RewardType.NEEDS:
        return Needs.fromMap(map["description"]);
      case RewardType.DECORATION:
        return Decoration.fromMap(map["description"]);
    }
  }

  @override
  String toString() {
    return "Reward(type: $category)";
  }
}

class Zone extends Reward {
  final String code;

  Zone.fromMap(Map<String, dynamic> map)
      : code = map["code"]!,
        super(RewardType.ZONE);

  @override
  String toString() {
    return "Zone(code: $code)";
  }
}

class Decoration extends Reward {
  final String code;
  final String type;

  Decoration.fromMap(Map<String, dynamic> map)
      : code = map["code"]!,
        type = map["type"]!,
        super(RewardType.DECORATION);

  @override
  String toString() {
    return "Decoration(code: $code, type: $type)";
  }
}

class Avatar extends Reward {
  final String code;
  final String type;

  Avatar.fromMap(Map<String, dynamic> map)
      : code = map["code"]!,
        type = map["type"]!,
        super(RewardType.AVATAR);

  @override
  String toString() {
    return "Avatar(code: $code, type: $type)";
  }
}

class Needs extends Reward {
  final int hunger;
  final int thirst;

  Needs.fromMap(Map<String, dynamic> map)
      : hunger = map["hunger"]!,
        thirst = map["thirst"]!,
        super(RewardType.NEEDS);

  @override
  String toString() {
    return "Needs(hunger: $hunger, thirst: $thirst)";
  }
}

class Points extends Reward {
  final int amount;

  Points.fromMap(Map<String, dynamic> map)
      : amount = map["amount"]!,
        super(RewardType.POINTS);

  @override
  String toString() {
    return "Points(amount: $amount)";
  }
}
