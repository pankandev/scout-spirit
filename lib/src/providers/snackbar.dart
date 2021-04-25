import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SnackBarProvider {
  static void showMessage(BuildContext context, String text,
      {ToastGravity gravity = ToastGravity.BOTTOM,
        Color color = Colors.black,
        Color textColor = Colors.white,
        IconData? icon,
        double iconSize = 36.0}) async {
    FToast fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 42.0, vertical: 18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48.0),
        color: color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: textColor,
              size: iconSize,
            ),
          if (icon != null)
            SizedBox(
              width: 24.0,
            ),
          Text(text, style: TextStyle(fontSize: 28.0, color: textColor)),
        ],
      ),
    );

    fToast.showToast(child: toast, gravity: gravity);
  }
}
