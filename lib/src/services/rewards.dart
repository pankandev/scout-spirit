import 'package:hive/hive.dart';
import 'package:scout_spirit/src/error/app_error.dart';
import 'package:scout_spirit/src/models/reward_token.dart';
import 'package:scout_spirit/src/models/rewards/reward.dart';
import 'package:scout_spirit/src/services/rest_api.dart';

class RewardsService extends RestApiService {
  static final RewardsService _instance = RewardsService._internal();

  Future<List<Reward>> claimReward(RewardToken token,
      {int? boxIndex}) async {
    Map<String, dynamic> body = {'token': token.token};
    if (token.body.boxes.length > 0) {
      if (boxIndex != null) {
        body['box_index'] = boxIndex;
      } else {
        throw new AppError(
            message: 'A box index must be given for this reward');
      }
    }
    Map<String, dynamic> response = await post('api/rewards/claim', body: body);
    List<Reward> rewards =
        (response["rewards"] as List).map((e) => Reward.fromMap(e)).toList();
    return rewards;
  }

  Box<String> get box {
    return Hive.box<String>('rewards');
  }

  Future<void> saveReward(RewardToken token) async {
    await box.put(token.body.id, token.token);
  }

  Future<List<RewardToken>> getUnclaimedRewards() async {
    return box.values.map((token) => RewardToken(token)).toList();
  }

  Future<RewardToken?> getNextReward() async {
    String? token = box.values.first;
    return token != null ? RewardToken(token) : null;
  }

  RewardsService._internal();

  factory RewardsService() {
    return _instance;
  }
}
