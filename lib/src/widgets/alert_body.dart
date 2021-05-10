import 'package:flutter/material.dart';

class AlertBody extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String body;
  final String cancelLabel;
  final String okLabel;
  final Function()? onOk;
  final Function()? onCancel;

  const AlertBody(
      {Key? key,
      required this.title,
      this.body = '',
      this.okLabel = 'OK',
      this.onOk,
      this.onCancel,
      this.cancelLabel = 'Cancelar',
      this.icon = Icons.warning_amber_rounded,
      this.color = Colors.redAccent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: Flex(
        mainAxisSize: MainAxisSize.min,
        direction: Axis.vertical,
        children: [
          Icon(icon, size: 64.0, color: color),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24.0,
                fontFamily: 'ConcertOne'),
          ),
          SizedBox(
            height: 16.0,
          ),
          if (body.isNotEmpty) Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
            child: Text(body, style: TextStyle(fontSize: 16.0), textAlign: TextAlign.center,),
          ),
          Flex(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (this.onCancel != null) RawMaterialButton(
                onPressed: this.onCancel,
                child: Text(
                  this.cancelLabel,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              if (this.onCancel != null) SizedBox(width: 16.0,),
              RawMaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                fillColor: color,
                onPressed: this.onOk,
                child: Text(
                  this.okLabel,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
