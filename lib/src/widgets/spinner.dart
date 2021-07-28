import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';

class Spinner extends StatelessWidget {
  final double size;
  final Color color;

  const Spinner({Key? key, this.size = 12.0, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(
      builder: (context, _, __, sx, sy) {
        return SizedBox(
          width: sx(size),
          height: sx(size),
          child: CircularProgressIndicator(
            strokeWidth: sx(size * 0.13),
              valueColor: AlwaysStoppedAnimation(color)),
        );
      }
    );
  }
}
