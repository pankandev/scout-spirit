import 'package:flutter/material.dart';

class LoadingScreenPage extends StatelessWidget {
  final String? label;
  final Color color;
  final double size;

  const LoadingScreenPage(
      {Key? key, this.label, this.color = Colors.white, this.size = 64.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: size,
                  width: size,
                  child: CircularProgressIndicator(
                    strokeWidth: 5.0,
                    valueColor: AlwaysStoppedAnimation(color),
                  )),
              SizedBox(
                height: 32.0,
              ),
              if (label != null)
                Text(
                  label!,
                  style: TextStyle(color: Colors.white, fontSize: 32.0),
                  textAlign: TextAlign.center,
                )
            ],
          ),
        ),
      ),
    );
  }
}
