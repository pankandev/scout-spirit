import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:scout_spirit/src/unity/unity_controller.dart';

class UnityApp extends StatefulWidget {
  final GameController controller;
  final String initialSceneName;
  final bool fullscreen;

  const UnityApp(
      {Key? key,
      required this.controller,
      required this.initialSceneName,
      this.fullscreen = true})
      : super(key: key);

  @override
  _UnityAppState createState() => _UnityAppState();
}

class _UnityAppState extends State<UnityApp> {
  late final Future<AndroidDeviceInfo> deviceInfo;

  @override
  void initState() {
    super.initState();
    deviceInfo = DeviceInfoPlugin().androidInfo;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await widget.controller.stop();
        return true;
      },
      child: FutureBuilder<AndroidDeviceInfo>(
        future: deviceInfo,
        builder: (context, snapshot) => !snapshot.hasData
            ? Center(child: CircularProgressIndicator())
            : (snapshot.data!.isPhysicalDevice
                ? UnityWidget(
                    onUnityCreated: _onUnityCreated,
                    onUnityMessage: onUnityMessage,
                    onUnitySceneLoaded: onUnitySceneLoaded,
                    enablePlaceholder: false,
                  )
                : Container()),
      ),
    );
  }

  void onUnityMessage(message) {
    widget.controller.handleUnityMessage(message);
  }

  void onUnitySceneLoaded(SceneLoaded? scene) {
    widget.controller.onNewScene(scene);
  }

  Future<void> _onUnityCreated(UnityWidgetController unityController) async {
    widget.controller.init(unityController);
    await widget.controller.goToScene(widget.initialSceneName);
  }
}
