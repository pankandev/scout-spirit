import 'package:flutter/material.dart';

typedef OnPop = Future<bool> Function();

class LoadingScreenPage extends StatelessWidget {
  final String? label;
  final Color color;
  final double size;
  final OnPop? onWillPop;

  const LoadingScreenPage(
      {Key? key, this.label, this.color = Colors.white, this.size = 64.0, this.onWillPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop ?? () async => false,
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
                height: 16.0,
              ),
              if (label != null)
                Text(
                  label!,
                  style: TextStyle(color: Colors.white, fontSize: 21.0, fontFamily: 'ConcertOne'),
                  textAlign: TextAlign.center,
                )
            ],
          ),
        ),
      ),
    );
  }
}
