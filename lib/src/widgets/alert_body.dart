import 'package:flutter/material.dart';
import 'package:scout_spirit/src/themes/constants.dart';

class AlertBody extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String body;
  final String cancelLabel;
  final String okLabel;
  final Function()? onOk;
  final Function()? onCancel;
  final Future<bool>? waitFor;

  const AlertBody(
      {Key? key,
      required this.title,
      this.body = '',
      this.okLabel = 'OK 👌',
      this.onOk,
      this.onCancel,
      this.cancelLabel = 'Cancelar',
      this.icon = Icons.warning_amber_rounded,
      this.color = Colors.redAccent,
      this.waitFor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Paddings.containerFluid,
      child: Flex(
        mainAxisSize: MainAxisSize.min,
        direction: Axis.vertical,
        children: [
          Icon(icon, size: IconSizes.xxlarge, color: color),
          if (title.isNotEmpty)
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyles.title.copyWith(fontFamily: 'Ubuntu'),
            ),
          VSpacings.medium,
          if (body.isNotEmpty)
            Padding(
              padding: Paddings.container,
              child: Text(
                body,
                style: TextStyles.dark.copyWith(fontSize: FontSizes.large),
                textAlign: TextAlign.center,
              ),
            ),
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (this.onCancel != null)
                RawMaterialButton(
                  onPressed: this.onCancel,
                  shape: Shapes.maxed,
                  child: Padding(
                    padding: Paddings.button,
                    child: Text(
                      this.cancelLabel,
                      style: TextStyles.buttonLight,
                    ),
                  ),
                ),
              if (this.onCancel != null)
                VSpacings.medium,
              Expanded(
                child: FutureBuilder<bool>(
                    future: waitFor ?? Future.value(true),
                    builder: (context, snapshot) {
                      bool enabled = snapshot.data ?? false;
                      return RawMaterialButton(
                        shape: Shapes.maxed,
                        fillColor: color,
                        onPressed: enabled ? this.onOk : null,
                        child: Padding(
                          padding: Paddings.button,
                          child: Text(
                            this.okLabel,
                            style: TextStyles.buttonDark,
                          ),
                        ),
                      );
                    }),
              )
            ],
          )
        ],
      ),
    );
  }
}
