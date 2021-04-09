import 'package:flutter/material.dart';
import 'package:scout_spirit/src/providers/reward_provider.dart';

class RewardOverlay extends StatefulWidget {
  final Widget? child;

  const RewardOverlay({Key? key, this.child}) : super(key: key);

  @override
  _RewardOverlayState createState() => _RewardOverlayState();
}

class _RewardOverlayState extends State<RewardOverlay> {
  @override
  void initState() {
    super.initState();
    RewardChecker().checkForRewards(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}
