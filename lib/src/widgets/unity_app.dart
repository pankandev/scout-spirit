import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:scout_spirit/src/themes/theme.dart';
import 'package:scout_spirit/src/unity/unity_controller.dart';
import 'package:scout_spirit/src/widgets/animated_loading_container.dart';
import 'package:scout_spirit/src/widgets/spinner.dart';

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

  late bool loading;

  @override
  void initState() {
    super.initState();
    deviceInfo = DeviceInfoPlugin().androidInfo;
    loading = true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await widget.controller.stop();
        return true;
      },
      child: Stack(
        children: [
          FutureBuilder<AndroidDeviceInfo>(
            future: deviceInfo,
            builder: (context, snapshot) => !snapshot.hasData
                ? Center(child: Spinner(color: appTheme.colorScheme.surface))
                : (snapshot.data!.isPhysicalDevice
                    ? UnityWidget(
                        onUnityCreated: _onUnityCreated,
                        onUnityMessage: onUnityMessage,
                        onUnitySceneLoaded: onUnitySceneLoaded,
                        placeholder: Center(
                            child:
                                Spinner(color: appTheme.colorScheme.surface)),
                        enablePlaceholder: false,
                      )
                    : Container()),
          ),
          if (loading) AnimatedLoadingContainer()
        ],
      ),
    );
  }

  void onUnityMessage(message) {
    widget.controller.handleUnityMessage(message);
  }

  Future<void> onUnitySceneLoaded(SceneLoaded? scene) async {
    await widget.controller.onNewScene(scene);
    if (loading && scene?.name == widget.initialSceneName) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _onUnityCreated(UnityWidgetController unityController) async {
    await widget.controller.init(unityController, widget.initialSceneName);
    if (loading) {
      setState(() {
        loading = false;
      });
    }
  }
}
