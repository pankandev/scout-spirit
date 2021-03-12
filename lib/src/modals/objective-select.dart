import 'package:flutter/material.dart';

class ObjectiveSelectModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.black.withAlpha(32),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              color: Colors.white,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
              ),
            ),
          ],
        )
      ],
    );
  }
}
