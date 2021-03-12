import 'package:flutter/material.dart';

class SnackBarProvider {
  static ScaffoldFeatureController _show(
      BuildContext context, SnackBar snackBar) {
    return Scaffold.of(context).showSnackBar(snackBar);
  }

  static ScaffoldFeatureController showMessage(
      BuildContext context, String message) {
    return _show(context, SnackBar(content: Text(message)));
  }
}
