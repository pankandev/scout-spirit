
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


class Reward {
  final RewardType type;
  final dynamic description;

  const Reward(this.type, this.description);

  factory Reward.fromMap(Map<String, dynamic> map) {
    return Reward(rewardTypeFromName(map["type"]), map["description"]);
  }
}