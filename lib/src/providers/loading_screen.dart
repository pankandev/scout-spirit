import 'package:scout_spirit/src/widgets/loading_screen.dart';
import 'package:flutter/material.dart';


class LoadingScreenProvider {
  static LoadingScreenProvider _instance = LoadingScreenProvider._internal();

  LoadingScreenProvider._internal();

  factory LoadingScreenProvider() {
    return _instance;
  }

  BuildContext? dialogContext;

  void show(BuildContext context, {String? label, OnPop? onWillPop}) {
    if (dialogContext != null) {
      return;
    }
    showDialog(context: context, builder: (context) {
      dialogContext = context;
      return LoadingScreenPage(label: label, onWillPop: onWillPop);
    });
  }

  void hide() {
    BuildContext? context = dialogContext;
    if (context == null) {
      return;
    }
    Navigator.pop(context);
    dialogContext = null;
  }
}