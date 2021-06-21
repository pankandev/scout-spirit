import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scout_spirit/src/error/app_error.dart';
import 'package:scout_spirit/src/models/log.dart';
import 'package:scout_spirit/src/models/reward_token.dart';
import 'package:scout_spirit/src/models/rewards/reward.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/logs.dart';
import 'package:scout_spirit/src/services/rest_api.dart';
import 'package:scout_spirit/src/utils/key.dart';

class RewardsService extends RestApiService {
  static final RewardsService _instance = RewardsService._internal();

  Future<List<Reward>> claimReward(RewardToken token, {int? boxIndex}) async {
    Map<String, dynamic> body = {'token': token.token};
    if (token.body.boxes.length > 0) {
      if (boxIndex != null) {
        body['box_index'] = boxIndex;
      } else {
        throw new AppError(
            message: 'A box index must be given for this reward');
      }
    }
    Map<String, dynamic> response;
    try {
      response = await post('api/rewards/claim', body: body);
    } on HttpError catch (e) {
      if (e.statusCode == 400) {
        box.delete(token.storageId);
      }
      rethrow;
    }
    List<Reward> rewards =
        (response["rewards"] as List).map((e) => Reward.fromMap(e)).toList();
    box.delete(token.storageId);
    return rewards;
  }

  Box<String> get box {
    return Hive.box<String>('rewards');
  }

  Future<void> saveReward(RewardToken token) async {
    await box.put(token.storageId, token.token);
  }

  Future<List<RewardToken>> getUnclaimedRewards() async {
    User user = AuthenticationService().snapAuthenticatedUser!;
    List<RewardToken> tokens = box.values
        .map((token) => RewardToken(token))
        .where((token) =>
                !token.isExpired && // is not expired
                token.body.sub == user.id && // belongs to user
                user.beneficiary!.lastClaimedToken <
                    token.body.index // has not been claimed
            )
        .toList();
    tokens.sort((a, b) => a.body.index - b.body.index);
    return tokens;
  }

  Future<RewardToken?> getNextReward() async {
    List<RewardToken> rewards = await getUnclaimedRewards();
    return rewards.length > 0 ? rewards[0] : null;
  }

  RewardsService._internal();

  factory RewardsService() {
    return _instance;
  }

  Future<void> updateCategory(String category) async {
    List<Log> rewardLogs;
    rewardLogs =
        await LogsService().getByCategory(joinKey(["REWARD", category]));
    List<Reward> rewards = rewardLogs
        .map<Reward>((e) => Reward.fromMap(e.data!))
        .toList();
    _getCategorySubject(category).sink.add(rewards);
  }

  BehaviorSubject<List<Reward>> _getCategorySubject(String category) {
    if (!rewardsByCategory.containsKey(category.toLowerCase())) {
      rewardsByCategory[category] = new BehaviorSubject<List<Reward>>();
    }
    return rewardsByCategory[category]!;
  }

  Stream<List<T>> getByCategory<T extends Reward>(String category) {
    return _getCategorySubject(category).stream.map((event) => event.cast<T>());
  }

  List<T> getSnapByCategory<T extends Reward>(String category) {
    List<Reward>? value = _getCategorySubject(category).value;
    return value.cast<T>();
  }

  final Map<String, BehaviorSubject<List<Reward>>> rewardsByCategory = {};

  void dispose() {
    rewardsByCategory.values.forEach((element) => element.close());
    rewardsByCategory.clear();
  }
}
