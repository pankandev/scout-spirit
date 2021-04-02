import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class UnityApp extends StatefulWidget {
  @override
  _UnityAppState createState() => _UnityAppState();
}

class _UnityAppState extends State<UnityApp> {
  UnityWidgetController? _unityWidgetController;

  @override
  Widget build(BuildContext context) {
    return UnityWidget(
      onUnityCreated: _onUnityCreated,
      onUnityMessage: onUnityMessage,
      onUnitySceneLoaded: onUnitySceneLoaded,
    );
  }

  void onUnityMessage(message) {
    print('Received message from unity: ${message.toString()}');
  }

  void onUnitySceneLoaded(SceneLoaded? scene) {
    print('Received scene loaded from unity: ${scene?.name}');
    print('Received scene loaded from unity buildIndex: ${scene?.buildIndex}');
  }

  void _onUnityCreated(UnityWidgetController controller) {
    this._unityWidgetController = controller;
  }
}
