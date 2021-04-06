import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/reward_token.dart';
import 'package:scout_spirit/src/pages/reward_claim.dart';
import 'package:scout_spirit/src/services/rewards.dart';

class RewardOverlay extends StatefulWidget {
  final Widget child;

  RewardOverlay({Key? key, required this.child}) : super(key: key);

  @override
  _RewardOverlayState createState() => _RewardOverlayState();
}

class _RewardOverlayState extends State<RewardOverlay> {

  @override
  void initState() {
    super.initState();
    _checkForRewards();
  }

  @override
  Widget build(BuildContext context) {
    return this.widget.child;
  }

  Future<void> _checkForRewards() async {
    RewardToken? reward = await RewardsService().getNextReward();
    while (reward != null) {
      RewardToken dialogReward = reward;
      await showDialog(
          context: context,
          builder: (context) => RewardClaimPage(reward: dialogReward));
      reward = await RewardsService().getNextReward();
    }
  }
}
