import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:scout_spirit/src/models/avatar.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:scout_spirit/src/error/unity_flutter_error.dart';
import 'package:scout_spirit/src/providers/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

const String RECEIVER_GAME_OBJECT = "Scout Spirit Flutter Messager";
const String RESPONSE_RECEIVER_METHOD = "ReceiveResponse";
const String SCENE_LOADING_METHOD = "GoToScene";

typedef UnityMessageHandler = Future<Map<String, dynamic>?> Function(
    Map<String, dynamic> arguments);

class GameController {
  static GameController _instance = GameController._internal();

  GameController._internal();

  factory GameController() {
    return _instance;
  }

  UnityWidgetController? _controller;
  SceneLoaded? _currentScene;

  SceneLoaded? get loadedScene => _currentScene;

  bool get initialized => _controller != null;

  void init(UnityWidgetController controller) {
    _controller = controller;
  }

  void onNewScene(SceneLoaded? scene) {
    _currentScene = scene;
  }

  Map<String, UnityMessageHandler> _handlers = {};

  void on(String method, UnityMessageHandler handler) {
    _handlers[method] = handler;
  }

  void off({String? method}) {
    if (method == null) {
      _handlers.clear();
      return;
    }

    if (_handlers.containsKey(method)) {
      _handlers.remove(method);
    }
  }

  Future<void> goToScene(String sceneName) async {
    if (_controller == null) {
      return;
    }
    await _controller!
        .postMessage(RECEIVER_GAME_OBJECT, SCENE_LOADING_METHOD, sceneName);
  }

  Future<void> handleUnityMessage(String message) async {
    final Map<String, dynamic> content = json.decode(message);
    final String method = content["method"];
    final int messageIndex = content["index"];
    if (method == "print") {
      if (!kReleaseMode) {
        print("[UNITY:LOG] ${content['arguments']}");
        Sentry.captureMessage("[UNITY:LOG] ${content['arguments']}");
      }
      await _sendResponse(messageIndex, response: null);
      return;
    }
    final Map<String, dynamic> arguments = content["arguments"];

    Map<String, dynamic>? response;
    UnityFlutterError? error;
    if (_handlers.containsKey(method)) {
      try {
        LoggerService()
            .log("UNITY_CONTROLLER", "Called method $method ($messageIndex)");
        response = await _handlers[method]!(arguments);
        LoggerService().log("UNITY_CONTROLLER",
            "Responded to request $messageIndex with response $response");
      } on UnityFlutterError catch (e) {
        error = e;
        LoggerService().warn("UNITY_CONTROLLER",
            "Received error to request $messageIndex with error ${e.message}");
        await _sendResponse(messageIndex, response: response, error: error);
        rethrow;
      } catch (_) {
        error = UnityFlutterError(
            code: "UNKNOWN", message: "An unknown error ocurred");
        await _sendResponse(messageIndex, response: response, error: error);
        rethrow;
      }
    } else {
      LoggerService().warn("UNITY_CONTROLLER",
          "Method '$method' called from Unity, but no handler exists for this method");
    }
  }

  Future<void> _sendResponse(int index,
      {Map<String, dynamic>? response, UnityFlutterError? error}) async {
    await _controller!
        .postJsonMessage(RECEIVER_GAME_OBJECT, RESPONSE_RECEIVER_METHOD, {
      "index": index,
      "response": response,
      "error":
          error != null ? {"code": error.code, "message": error.message} : null
    });
  }

  Future<void> takeScreenshot(String filename) async {
    await _controller!
        .postMessage(RECEIVER_GAME_OBJECT, "TakeScreenshot", filename);
  }

  Future<void> changeAvatarClothes(
      String targetGameObject, Avatar? clothes) async {
    Map<String, dynamic> map = clothes?.toMap() ?? (new Avatar()).toMap();
    await _controller!.postJsonMessage(targetGameObject, "ChangeClothes", map);
  }

  Future<void> stop() async {
    await goToScene("Hub");
    _controller = null;
  }

  Future<bool> _isPaused() async {
    return await _controller!.isPaused() ?? false;
  }

  Future<void> pause() async {
    UnityWidgetController? controller = _controller;
    bool isPaused = await _isPaused();
    if (controller != null && !isPaused) {
      await controller.pause();
    }
  }

  Future<void> resume() async {
    UnityWidgetController? controller = _controller;
    if (controller != null) {
      await controller.resume();
    }
  }
}
