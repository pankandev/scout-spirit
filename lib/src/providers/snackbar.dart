import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scout_spirit/src/pages/alert_dialog.dart';

class SnackBarProvider {
  static void showMessage(BuildContext context, String text,
      {ToastGravity gravity = ToastGravity.TOP,
      Color color = Colors.black,
      Color textColor = Colors.white,
      IconData? icon,
      double iconSize = 36.0}) async {
    FToast fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 9.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48.0),
        color: color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: textColor,
              size: iconSize,
            ),
          if (icon != null)
            SizedBox(
              width: 12.0,
            ),
          Text(text, style: TextStyle(fontSize: 14.0, color: textColor)),
        ],
      ),
    );

    fToast.showToast(child: toast, gravity: gravity);
  }

  static Future<bool> showConfirmAlert(BuildContext context, String title,
      {Color color = Colors.redAccent,
      IconData icon = Icons.warning_amber_rounded,
      Curve animationCurve = Curves.bounceOut,
      Duration animationDuration = const Duration(milliseconds: 600),
      String body = '',
      String cancelLabel = 'Cancelar',
      String okLabel = 'OK 👌'}) async {
    return await showGeneralDialog<bool>(
            context: context,
            barrierColor: Colors.black.withOpacity(0.5),
            transitionBuilder: (context, a1, a2, widget) {
              return Transform.scale(
                  scale: animationCurve.transform(a1.value),
                  child: Opacity(
                    opacity: animationCurve.transform(a1.value),
                    child: widget,
                  ));
            },
            transitionDuration: animationDuration,
            barrierDismissible: true,
            barrierLabel: '',
            pageBuilder: (context, a1, a2) => ScoutAlertDialog<bool>(
                  color: color,
                  icon: icon,
                  title: title,
                  body: body,
                  cancelLabel: cancelLabel,
                  okLabel: okLabel,
                  okValue: true,
                )) ??
        false;
  }
}
