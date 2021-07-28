import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:scout_spirit/src/themes/theme.dart';
import 'package:scout_spirit/src/widgets/spinner.dart';

class AnimatedLoadingContainer extends StatefulWidget {
  const AnimatedLoadingContainer({Key? key}) : super(key: key);

  @override
  _AnimatedLoadingContainerState createState() =>
      _AnimatedLoadingContainerState();
}

class _AnimatedLoadingContainerState extends State<AnimatedLoadingContainer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Tween<double> _tween = Tween(begin: 0.4, end: 1);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 2400), vsync: this);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = _tween
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    return RelativeBuilder(builder: (context, _, __, sx, sy) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, _) => Container(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Spinner(
                    color: appTheme.colorScheme.surface,
                    size: 24.0,
                  ),
                  SizedBox(height: sx(12.0)),
                  Text(
                    'Cargando',
                    style: TextStyle(
                        fontSize: sx(14.0),
                        fontFamily: 'Ubuntu',
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
                gradient: RadialGradient(
                    center: Alignment.center,
                    radius: animation.value,
                    colors: <Color>[
                  appTheme.colorScheme.primary,
                  appTheme.colorScheme.secondary,
                ]))),
      );
    });
  }
}
