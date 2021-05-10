import 'package:flutter/material.dart';
import 'package:scout_spirit/src/widgets/scout_button.dart';
import 'package:scout_spirit/src/widgets/scout_outlined_button.dart';

class NavigationButtons extends StatefulWidget {
  final PageController? pageController;
  final Function(int page)? onPageChange;
  final List<String> labels;

  const NavigationButtons(
      {Key? key,
      this.pageController,
      required this.labels,
      required this.onPageChange})
      : super(key: key);

  @override
  _NavigationButtonsState createState() => _NavigationButtonsState();
}

class _NavigationButtonsState extends State<NavigationButtons> {
  int page = 0;

  @override
  void initState() {
    super.initState();
    page = widget.pageController?.initialPage ?? 0;
    widget.pageController?.addListener(updatePage);
  }

  @override
  void dispose() {
    super.dispose();
    widget.pageController?.removeListener(updatePage);
  }

  void updatePage() {
    setState(() {
      page = widget.pageController!.page!.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Flex(
        direction: Axis.horizontal,
        children: widget.labels.asMap().keys.map((index) {
          String label = widget.labels[index];
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
    Function(int page)? onChange = widget.onPageChange;
    return ScoutOutlinedButton(
        label: label, onPressed: onChange != null ? onChange(index) : null);
  }
}
