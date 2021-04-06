import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/rewards/reward.dart';

class RewardsPage extends StatelessWidget {
  final List<Reward> rewards;

  final PageController _pageController = PageController();

  RewardsPage({Key? key, required List<Reward> rewards})
      : rewards = rewards
            .where((reward) => [
                  RewardType.AVATAR,
                  RewardType.DECORATION,
                  RewardType.POINTS,
                  RewardType.ZONE
                ].contains(reward.category))
            .toList(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: PageView.builder(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, int index) => RewardItem(
                  reward: rewards[index], onConfirm: () => nextPage(context)),
              itemCount: rewards.length),
        ),
      ),
    );
  }

  Future<void> nextPage(BuildContext context) async {
    int nextPage = _pageController.page!.round() + 1;
    if (nextPage < rewards.length) {
      await _pageController.animateToPage(nextPage,
          duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
    } else {
      Navigator.pop(context);
    }
  }
}

class RewardItem extends StatelessWidget {
  final Reward reward;
  final Function()? onConfirm;

  const RewardItem({Key? key, required this.reward, this.onConfirm})
      : super(key: key);

  String getRewardName() {
    switch (reward.category) {
      case RewardType.ZONE:
        return "Zona";
      case RewardType.AVATAR:
        return "Prenda para el Ávatar";
      case RewardType.POINTS:
        return "Puntos";
      case RewardType.NEEDS:
        return "Alimento y agua";
      case RewardType.DECORATION:
        return "Decoración";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.ac_unit, size: MediaQuery.of(context).size.height * 0.4),
          Text(
            getRewardName(),
            style: TextStyle(fontSize: 24.0),
          ),
          SizedBox(
            height: 32.0,
          ),
          if (onConfirm != null)
            TextButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.done, size: 42.0, color: Colors.green),
                        SizedBox(width: 10.0,),
                        Text('Confirmar', style: TextStyle(fontSize: 21.0, color: Colors.green))
                      ]),
                ),
                onPressed: onConfirm)
        ],
      ),
    );
  }
}
