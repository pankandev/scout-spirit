import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/reward_token.dart';
import 'package:scout_spirit/src/pages/reward_claim.dart';
import 'package:scout_spirit/src/services/rewards.dart';

class RewardChecker {
  static RewardChecker _instance = RewardChecker._internal();

  factory RewardChecker() {
    return _instance;
  }

  Future<void> checkForRewards(BuildContext context) async {
    RewardToken? reward = await RewardsService().getNextReward();
    while (reward != null) {
      RewardToken dialogReward = reward;
      await showDialog(
          context: context,
          builder: (context) => RewardClaimPage(reward: dialogReward));
      reward = await RewardsService().getNextReward();
    }
  }

  RewardChecker._internal();
}