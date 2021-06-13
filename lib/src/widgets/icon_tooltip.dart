import 'package:flutter/material.dart';
import 'package:scout_spirit/src/providers/snackbar.dart';

class IconTooltip extends StatelessWidget {
  final String label;
  final double size;

  const IconTooltip(this.label, {Key? key, this.size = 24.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: size,
      icon: Icon(
        Icons.help_outline,
        color: Colors.white,
      ),
      onPressed: () => SnackBarProvider.showPopTooltip(
          context, '',
          body: label),
    );
  }
}
