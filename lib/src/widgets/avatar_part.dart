import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/rewards/reward.dart';

class AvatarPartCard extends StatelessWidget {
  final AvatarPart? part;

  const AvatarPartCard({Key? key, required this.part}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: AspectRatio(
            aspectRatio: 1,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0)),
                child: Center(child: Text(part?.toString() ?? 'Por defecto')))));
  }
}
