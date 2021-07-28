import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/rewards/reward.dart';
import 'package:scout_spirit/src/themes/constants.dart';
import 'package:scout_spirit/src/widgets/background.dart';
import 'package:scout_spirit/src/widgets/scout_outlined_button.dart';

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

  String get rewardEmoji {
    switch (reward.category) {
      case RewardType.ZONE:
        return "🌳";
      case RewardType.AVATAR:
        return "👔";
      case RewardType.POINTS:
        return "💯";
      case RewardType.NEEDS:
        return "🥕";
      case RewardType.DECORATION:
        return "✨";
    }
  }

  String get rewardDescription {
    switch (reward.category) {
      case RewardType.ZONE:
        return "Tal parece que se ha abierto un nuevo camino en tu mundo 😯";
      case RewardType.AVATAR:
        return "Una nueva prenda con la que puedes personalizar tu ávatar 😎";
      case RewardType.POINTS:
        return "Unos cuantos puntos extra nunca vienen mal ✨";
      case RewardType.NEEDS:
        return "";
      case RewardType.DECORATION:
        return "Tal parece que llegó un paquete a tu mundo 📬";
    }
  }

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
      child: Stack(
        children: [
          Background(),
          Padding(
            padding: Paddings.containerXFluid,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  rewardEmoji,
                  style: TextStyle(fontSize: FontSizes.giant),
                  textAlign: TextAlign.center,
                ),
                Text(getRewardName(),
                    style: TextStyles.title.copyWith(
                        fontSize: FontSizes.max,
                        color: Colors.white,
                        fontWeight: FontWeight.w200),
                    textAlign: TextAlign.center),
                VSpacings.giant,
                Text(rewardDescription,
                    style: TextStyles.bodyLight
                        .copyWith(fontSize: FontSizes.large, height: 1.4),
                    textAlign: TextAlign.center),
                VSpacings.giant,
                if (onConfirm != null)
                  ScoutOutlinedButton(
                    onPressed: onConfirm,
                    label: 'Confirmar',
                    labelSize: 76.0,
                    icon: Icons.check,
                    padding: Paddings.buttonLoose,
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
