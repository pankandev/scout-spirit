import 'package:flutter/material.dart';
import 'package:scout_spirit/src/themes/constants.dart';
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
            child: Text(
              value.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: FontSizes.xxlarge,
                  shadows: <Shadow>[Shadows.glow],
                  fontFamily: 'ConcertOne'),
            )),
        VSpacings.large,
        Flexible(
            child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(210, 210, 210, 1),
                    fontSize: FontSizes.medium,
                    height: 1.05,
                    fontFamily: 'ConcertOne'),
              ),
            ),
          ],
        )),
        if (tooltip != null) Flexible(child: Padding(
          padding: Paddings.top,
          child: IconTooltip(tooltip!),
        )),
      ],
    );
  }
}

class LabelValueBox<T> extends LabelValue<T> {
  final EdgeInsets? padding;
  final String label;
  final T value;

  LabelValueBox(
      {Key? key,
      required this.label,
      required this.value,
      this.padding})
      : super(key: key, label: label, value: value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? Paddings.containerFluid.copyWith(bottom: Dimensions.xlarge),
      decoration: BoxDecoration(
        borderRadius: BorderRadii.medium,
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
                color: Colors.white, fontSize: FontSizes.medium, fontFamily: 'ConcertOne'),
          )),
          VSpacings.medium,
          Flexible(
              child: Text(
            value.toString(),
            style: TextStyle(
                color: Colors.white,
                fontSize: FontSizes.xxlarge,
                shadows: <Shadow>[Shadows.glow],
                fontFamily: 'ConcertOne'),
          )),
        ],
      ),
    );
  }
}
