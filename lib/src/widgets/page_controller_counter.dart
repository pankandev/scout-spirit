import 'package:flutter/material.dart';

class PageControllerListener extends StatefulWidget {
  final PageController controller;
  final Widget Function(int page) builder;

  const PageControllerListener({Key? key, required this.controller, required this.builder}) : super(key: key);

  @override
  _PageControllerListenerState createState() => _PageControllerListenerState();
}

class _PageControllerListenerState extends State<PageControllerListener> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onChange);
  }

  int page = 0;

  void onChange() {
    setState(() {
      page = widget.controller.page!.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(page);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(onChange);
  }
}
