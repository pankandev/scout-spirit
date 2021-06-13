import 'package:flutter/material.dart';
import 'package:scout_spirit/src/widgets/icon_tooltip.dart';

class LabelValue<T> extends StatelessWidget {
  final String label;
  final T value;
  final String? tooltip;

  const LabelValue({Key? key, required this.label, required this.value, this.tooltip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
            child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(210, 210, 210, 1),
                    fontFamily: 'ConcertOne'),
              ),
            ),
          ],
        )),
        SizedBox(
          height: 8.0,
        ),
        Flexible(
            child: Text(
          value.toString(),
          style: TextStyle(
              color: Colors.white,
              fontSize: 32.0,
              shadows: <Shadow>[Shadow(color: Colors.white, blurRadius: 13.0)],
              fontFamily: 'ConcertOne'),
        )),
        if (tooltip != null) Flexible(child: IconTooltip(tooltip!)),
      ],
    );
  }
}

class LabelValueBox<T> extends LabelValue<T> {
  final EdgeInsets padding;
  final String label;
  final T value;

  LabelValueBox(
      {Key? key,
      required this.label,
      required this.value,
      this.padding = const EdgeInsets.only(top: 8.0, bottom: 20.0)})
      : super(key: key, label: label, value: value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.white, width: 2.0),
      ),
      child: Flex(
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 13.0, fontFamily: 'ConcertOne'),
          )),
          SizedBox(
            height: 8.0,
          ),
          Flexible(
              child: Text(
            value.toString(),
            style: TextStyle(
                color: Colors.white,
                fontSize: 28.0,
                shadows: <Shadow>[
                  Shadow(color: Colors.white, blurRadius: 13.0)
                ],
                fontFamily: 'ConcertOne'),
          )),
        ],
      ),
    );
  }
}
