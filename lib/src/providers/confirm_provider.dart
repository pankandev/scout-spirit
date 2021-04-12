import 'package:flutter/material.dart';

class ConfirmProvider {
  static Future<bool> askConfirm(BuildContext context,
      {required String question, String? content}) async {
    bool? result = await showDialog<bool>(
        context: context, builder: (context) =>
        AlertDialog(
          title: Text(question),
          content: content != null ? Text(
            content,
            textAlign: TextAlign.justify,
          ) : null,
          actions: [
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((
                        states) => Colors.grey)
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancelar'))
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((
                        states) => Colors.blueAccent)
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Sí!')),
          ],
        ));
    if (result == null) {
      return false;
    }
    return result;
  }
}