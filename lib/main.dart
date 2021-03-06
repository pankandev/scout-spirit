import 'package:flutter/material.dart';

void main() => runApp(ScoutSpiritApp());

class ScoutSpiritApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Scout Spirit App',
        home: Scaffold(
            appBar: AppBar(
              title: Text('Scout Spirit App Bar'),
            ),
            body: Center(
                child: Container(
              child: Text('Hello World'),
            ))));
  }
}
