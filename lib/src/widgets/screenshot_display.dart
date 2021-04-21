import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';

class ScreenshotDisplay extends StatelessWidget {
  final File screenshot;

  final GlobalKey<CropState> cropKey = GlobalKey<CropState>();

  ScreenshotDisplay({Key? key, required this.screenshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Dialog(
              child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Crop(
                      key: cropKey,
                      image: Image.file(screenshot).image,
                      aspectRatio: 1.0,
                      alwaysShowGrid: false,
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () => _finishCrop(context),
                    child: Icon(Icons.save))
              ],
            ),
          )),
        ],
      ),
    );
  }

  Future<void> _finishCrop(BuildContext context) async {
    CropState? crop = cropKey.currentState;
    if (crop == null) {
      Navigator.pop(context);
      return;
    }
    final bool permissionsGranted = await ImageCrop.requestPermissions();
    if (permissionsGranted) {
      final File croppedFile = await ImageCrop.cropImage(
        file: screenshot,
        area: crop.area!,
      );
      Navigator.pop(context, croppedFile);
      return;
    }
    Navigator.pop(context);
  }
}
