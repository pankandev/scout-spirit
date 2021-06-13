import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Color? primary;
  final Color? secondary;

  const Background({Key? key, this.primary, this.secondary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      height: screenSize.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            primary ?? Color.fromRGBO(77, 148, 255, 1),
            secondary ?? Color.fromRGBO(99, 39, 226, 1),
          ]
        )
      ),
    );
  }
}
