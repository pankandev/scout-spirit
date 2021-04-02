import 'package:flutter/material.dart';

class ClickableText extends StatelessWidget {
  final String label;
  final void Function()? onTap;

  const ClickableText({Key? key, required this.label, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Text(this.label),
        onTap: onTap);
  }
}
