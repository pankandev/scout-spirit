import 'package:flutter/material.dart';

class AdvancedPageController extends PageController {
  AdvancedPageController({
    int initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 1.0,
  }) : super(
            initialPage: initialPage,
            keepPage: keepPage,
            viewportFraction: viewportFraction);

  Future<void> animateToNextPage(
      {required Duration duration, required Curve curve}) async {
    return await animateToRelativePage(1, duration: duration, curve: curve);
  }

  Future<void> animateToPreviousPage(
      {required Duration duration, required Curve curve}) async {
    return await animateToRelativePage(-1, duration: duration, curve: curve);
  }

  Future<void> animateToRelativePage(int delta,
      {required Duration duration, required Curve curve}) async {
    int currentPage = page!.round();
    return await animateToPage(currentPage + delta,
        duration: duration, curve: curve);
  }
}
