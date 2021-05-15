import 'package:flutter/material.dart';
import 'package:scout_spirit/src/widgets/scout_button.dart';
import 'package:scout_spirit/src/widgets/scout_outlined_button.dart';

class NavigationButtons extends StatelessWidget {
  final int page;
  final List<String> labels;
  final Function(int page)? onPageChange;

  const NavigationButtons({Key? key, this.page = 0, required this.labels, required this.onPageChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Flex(
        direction: Axis.horizontal,
        children: labels.asMap().keys.map((index) {
          String label = labels[index];
          return index == page
              ? Expanded(
                  child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildFilledButton(label),
                ))
              : Expanded(
                  child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildEmptyButton(index, label),
                ));
        }).toList(),
      ),
    );
  }

  Widget _buildFilledButton(String label) {
    return ScoutButton(
        label: label,
        mainAxisSize: MainAxisSize.max,
        fillColor: Colors.white,
        accentColor: Color.fromRGBO(199, 180, 255, 1),
        labelColor: Color.fromRGBO(135, 92, 255, 1),
        onPressed: null);
  }

  Widget _buildEmptyButton(int index, String label) {
    Function(int page)? onChange = onPageChange;
    return ScoutOutlinedButton(
        label: label, onPressed: onChange != null ? () => onChange(index) : null);
  }
}
