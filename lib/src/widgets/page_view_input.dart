import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scout_spirit/src/providers/provider_consumer.dart';
import 'package:scout_spirit/src/utils/advanced_page_controller.dart';

class PageViewInput<T> extends StatefulWidget {
  final ValueNotifier<T> controller;
  final List<T> options;
  final Widget Function(BuildContext context, T value) builder;
  final Duration transitionDuration;
  final Curve transitionCurve;
  final ScrollPhysics physics;
  final Alignment counterAlignment;
  final void Function(T newPage)? onChange;
  final Widget Function(int index, int total)? counterBuilder;

  PageViewInput(
      {Key? key,
      required this.controller,
      required this.options,
      required this.builder,
      this.onChange,
      this.counterBuilder,
      this.counterAlignment = Alignment.topRight,
      this.physics = const AlwaysScrollableScrollPhysics(),
      this.transitionDuration = const Duration(milliseconds: 200),
      this.transitionCurve = Curves.easeInOut})
      : super(key: key);

  @override
  _PageViewInputState<T> createState() => _PageViewInputState<T>();
}

class _PageViewInputState<T> extends State<PageViewInput<T>> {
  late final AdvancedPageController _pageController;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onChange);
    _pageController = new AdvancedPageController(initialPage: getItemIndex(widget.controller.value));
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(onChange);
  }

  @override
  Widget build(BuildContext context) {
    return ProviderConsumer(
        controller: widget.controller,
        builder: (_) => Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: IconButton(
                        icon: Icon(
                          Icons.arrow_left,
                          color: Colors.white,
                          size: 64.0,
                        ),
                        onPressed: () => _pageController.animateToPreviousPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut))),
                Expanded(
                  flex: 2,
                  child: PageView.builder(
                    physics: widget.physics,
                    controller: _pageController,
                    itemCount: widget.options.length,
                    onPageChanged: (page) {
                      widget.controller.value = widget.options[page];
                    },
                    itemBuilder: (BuildContext context, int index) =>
                        Stack(children: [
                      Positioned.fill(
                          child:
                              widget.builder(context, widget.options[index])),
                      if (widget.counterBuilder != null)
                        Align(
                            alignment: widget.counterAlignment,
                            child: widget.counterBuilder!(
                                index, widget.options.length)),
                    ]),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: IconButton(
                        icon: Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                          size: 64.0,
                        ),
                        onPressed: () => _pageController.animateToNextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut))),
              ],
            ));
  }

  void onChange() {
    T newValue = widget.controller.value;
    int newPage = getItemIndex(newValue);
    if (newPage >= 0) {
      _pageController.animateToPage(newPage,
          duration: widget.transitionDuration, curve: widget.transitionCurve);
    }
    if (widget.onChange != null) {
      widget.onChange!(newValue);
    }
  }

  int getItemIndex(T value) {
    return widget.options.indexOf(value);
  }
}
