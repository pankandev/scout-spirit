import 'package:flutter/material.dart';

final appTheme = ThemeData.light().copyWith(
  backgroundColor: Color.fromRGBO(73, 233, 255, 1),
  accentColor: Color.fromRGBO(71, 48, 207, 1),
  textTheme: ThemeData.light().textTheme.copyWith(
        headline1: TextStyle(color: Color(0xff3a3b45), fontSize: 24.0),
        headline2: TextStyle(color: Color(0xff3a3b45), fontSize: 18.0),
      ),
  primaryColor: Color.fromRGBO(70, 26, 194, 1),
  errorColor: Colors.pinkAccent
);

final TextStyle mutedTextTheme = ThemeData.light().textTheme.caption!;
