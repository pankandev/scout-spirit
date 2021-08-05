import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scout_spirit/src/error/app_error.dart';
import 'package:scout_spirit/src/models/reward_token.dart';
import 'package:scout_spirit/src/models/rewards/reward.dart';
import 'package:scout_spirit/src/providers/logger.dart';
import 'package:scout_spirit/src/services/rewards.dart';
import 'package:scout_spirit/src/themes/constants.dart';

class RewardClaimPage extends StatefulWidget {
  final RewardToken reward;

  RewardClaimPage({Key? key, required this.reward}) : super(key: key);

  @override
  _RewardClaimPageState createState() => _RewardClaimPageState();
}

class _RewardClaimPageState extends State<RewardClaimPage> {
  bool loading = false;
  final ConfettiController _confettiController =
      ConfettiController(duration: Duration(seconds: 1));

  @override
  void initState() {
    super.initState();
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Center(
            child: Padding(
              padding: Paddings.containerXFluid,
              child: SingleChildScrollView(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadii.max),
                    padding: Paddings.container,
                    child: Flex(
                      direction: Axis.vertical,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '¡Felicitaciones!',
                          style: TextStyles.title,
                        ),
                        VSpacings.large,
                        Text('Elige una recompensa!',
                            style: TextStyles.subtitle.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                                fontFamily: 'Ubuntu')),
                        VSpacings.large,
                        _buildBoxesList(),
                      ],
                    )),
              ),
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: pi / 2,
                emissionFrequency: 0.01,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 120,
                maxBlastForce: 20,
                minBlastForce: 15,
                gravity: 0.1,
              ))
        ]),
      ),
    );
  }

  Widget _buildBoxesList() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      children: widget.reward.body.boxes
          .asMap()
          .keys
          .map((index) => Padding(
                padding: Paddings.allLarge,
                child: RawMaterialButton(
                    textStyle: TextStyle(color: Colors.white),
                    shape: CircleBorder(),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: Paddings.allMedium,
                            child: Image.asset('assets/imgs/gift.png', fit: BoxFit.contain,),
                          ),
                          Text('Loot #$index',
                              style: TextStyles.buttonLight.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'UbuntuCondensed'))
                        ],
                      ),
                    ),
                    onPressed:
                        loading ? null : () => claimReward(boxIndex: index)),
              ))
          .toList(),
    );
  }

  Future<void> claimReward({int? boxIndex}) async {
    setState(() {
      loading = true;
    });
    List<Reward> rewards;
    try {
      rewards =
          await RewardsService().claimReward(widget.reward, boxIndex: boxIndex);
    } on HttpError catch (e, s) {
      if (e.statusCode == 400) {
        Navigator.of(context).pop();
        return;
      } else {
        setState(() {
          loading = true;
        });
        await LoggerService().error(e, s);
        rethrow;
      }
    } catch (e, s) {
      setState(() {
        loading = false;
      });
      await LoggerService().error(e, s);
      rethrow;
    }
    NavigatorState nav = Navigator.of(context);
    await nav.pushNamed('/rewards/claim', arguments: rewards);
    nav.pop();
  }
}
