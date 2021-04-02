import 'dart:convert';

import 'package:jose/jose.dart';
import 'package:scout_spirit/src/error/app_error.dart';
import 'package:scout_spirit/src/models/rewards/reward.dart';

enum RewardRarity { COMMON, RARE }


RewardRarity _rarityFromName(String name) {
  switch (name.toUpperCase()) {
    case 'COMMON':
      return RewardRarity.COMMON;
    case 'RARE':
      return RewardRarity.RARE;
  }
  throw new AppError(message: 'Unknown reward rarity: $name');
}

class RewardProbability {
  RewardType type;
  RewardRarity rarity;

  RewardProbability.fromMap(Map<String, dynamic> map)
      : type = rewardTypeFromName(map["type"]),
        rarity = _rarityFromName(map["rarity"]);

  @override
  String toString() {
    return "RewardProbability(type: $type, rarity: $rarity)";
  }
}

class RewardSet {
  List<RewardProbability> rewards;

  RewardSet.fromList(List<dynamic> list)
      : rewards = list.map((e) => RewardProbability.fromMap(e)).toList();

  @override
  String toString() {
    return "RewardSet(rewards: $rewards)";
  }
}

class RewardTokenBody {
  final String id;
  final String sub;
  final int iat;
  final int exp;

  final RewardSet static;
  final List<RewardSet> boxes;

  RewardTokenBody.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        sub = map["sub"],
        iat = map["iat"],
        exp = map["exp"],
        static = RewardSet.fromList(map["static"]),
        boxes =
            (map["boxes"] as List).map((e) => RewardSet.fromList(e)).toList();

  @override
  String toString() {
    return "RewardTokenBody(id: $id, sub: $sub, iat: $iat, exp: $exp, static: $static, boxes: $boxes)";
  }
}

class RewardToken {
  final String token;
  final RewardTokenBody body;

  RewardToken(String encodedToken)
      : token = encodedToken,
        body = RewardTokenBody.fromMap(json.decode(
            JsonWebSignature.fromCompactSerialization(encodedToken)
                .unverifiedPayload
                .stringContent));

  @override
  String toString() {
    return "RewardToken(body: $body)";
  }
}
