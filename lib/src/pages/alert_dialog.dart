import 'package:flutter/material.dart';
import 'package:scout_spirit/src/widgets/alert_body.dart';

class ScoutAlertDialog<T> extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String body;
  final String cancelLabel;
  final String okLabel;
  final T okValue;

  const ScoutAlertDialog(
      {Key? key,
      this.color = Colors.redAccent,
      this.icon = Icons.warning_amber_rounded,
      this.title = '¡Atención!',
      this.body = '',
      this.cancelLabel = 'Cancelar',
      this.okLabel = 'OK',
      required this.okValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Dialog(
        child: AlertBody(
          color: color,
          icon: icon,
          title: title,
          body: body,
          cancelLabel: cancelLabel,
          okLabel: okLabel,
          onOk: () {
            Navigator.pop(context, okValue);
          },
          onCancel: () {
            Navigator.pop(context, T == bool ? false : null);
          },
        ),
      ),
    );
  }
}
