import 'dart:async';
import 'dart:convert';

import 'package:scout_spirit/src/error/app_error.dart';
import 'package:scout_spirit/src/models/avatar.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:scout_spirit/src/error/unity_flutter_error.dart';
import 'package:scout_spirit/src/providers/logger.dart';

const String RECEIVER_GAME_OBJECT = "Scout Spirit Flutter Messager";
const String METHOD_RESPONSE_RECEIVER = "ReceiveResponse";
const String METHOD_SCENE_LOADING = "GoToScene";
const String METHOD_SAVE = "Save";
const String METHOD_SCREENSHOT = "TakeScreenshot";


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

  Future<void> init(UnityWidgetController controller, String atScene) async {
    _controller = controller;
    bool isPaused = await controller.isPaused() ?? true;
    if (isPaused) {
      await Future.delayed(Duration(milliseconds: 500));
      await controller.resume();
    }
    await goToScene(atScene);
  }

  Future<void> onNewScene(SceneLoaded? scene) async {
    _currentScene = scene;
    await LoggerService()
        .log('UNITY_CONTROLLER', 'Loaded scene: ${scene?.name}');
  }

  Map<String, UnityMessageHandler> _handlers = {};

  final StreamController<String> calledMethodsController = StreamController<String>.broadcast();
  Stream<String> get calledMethods$ => calledMethodsController.stream;

  void dispose() {
    calledMethodsController.close();
  }

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
        .postMessage(RECEIVER_GAME_OBJECT, METHOD_SCENE_LOADING, sceneName);
  }

  Future<void> handleUnityMessage(String message) async {
    final Map<String, dynamic> content = json.decode(message);
    final String method = content["method"];
    final int messageIndex = content["index"];

    if (method == "print") {
      await LoggerService().log("UNITY:LOG", content["arguments"].toString());
      await _sendResponse(messageIndex, response: null);
      return;
    }
    final Map<String, dynamic> arguments = content["arguments"] ?? {};

    Map<String, dynamic>? response;
    UnityFlutterError? error;
    UnityMessageHandler? handler = _handlers[method];
    if (handler != null) {
      try {
        // execute handler
        response = await handler(arguments);
        await LoggerService().log("UNITY_CONTROLLER", "Response $messageIndex",
            params: [method, response]);
        await _sendResponse(messageIndex, response: response, error: error);
      } on UnityFlutterError catch (e, s) {
        // return on error
        error = e;
        await _sendResponse(messageIndex, response: response, error: error);
        await LoggerService()
            .warn("UNITY_CONTROLLER", "Error $messageIndex: ${e.message}");
        await LoggerService().error(e, s);
      } catch (e, s) {
        // handle error
        await _sendResponse(messageIndex, response: response, error: error);
        error = UnityFlutterError(
            code: "UNKNOWN", message: "An unknown error ocurred");
        await LoggerService().error(e, s);
      }
      calledMethodsController.add(method);
    } else {
      await LoggerService().warn("UNITY_CONTROLLER",
          "Method '$method' called from Unity, but no handler exists for this method");
    }
  }

  Future<void> _sendResponse(int index,
      {Map<String, dynamic>? response, UnityFlutterError? error}) async {
    UnityWidgetController? controller = _controller;
    if (controller == null) {
      LoggerService().warn('UNITY_CONTROLLER',
          'Trying to send response, but controller is not initialized');
      return;
    }
    await controller.postMessage(
        RECEIVER_GAME_OBJECT,
        METHOD_RESPONSE_RECEIVER,
        json.encode({
          "index": index,
          "response": response,
          "error": error != null
              ? {"code": error.code, "message": error.message}
              : null
        }));
  }

  Future<void> takeScreenshot(String filename) async {
    await controller.postMessage(
        RECEIVER_GAME_OBJECT, METHOD_SCREENSHOT, filename);
  }

  Future<void> changeAvatarClothes(
      String targetGameObject, Avatar? clothes) async {
    Map<String, dynamic> map = clothes?.toMap() ?? (new Avatar()).toMap();
    await _controller!.postJsonMessage(targetGameObject, "ChangeClothes", map);
  }

  Future<void> stop() async {
    UnityWidgetController? controller = _controller;
    if (controller != null) {
      await goToScene("Hub");
      await controller.pause();
    }
  }

  Future<bool> _isPaused() async {
    return await controller.isPaused() ?? false;
  }

  Future<void> pause() async {
    UnityWidgetController? controller = _controller;
    bool isPaused = await _isPaused();
    if (controller != null && !isPaused) {
      await controller.pause();
    }
  }

  UnityWidgetController get controller {
    UnityWidgetController? c = _controller;
    if (c == null) {
      throw new AppError(
          message:
              'Trying to send response, but controller is not initialized');
    }
    return c;
  }

  Future<void> resume() async {
    UnityWidgetController? controller = _controller;
    if (controller != null) {
      await controller.resume();
    }
  }

  Future<void> waitForNextCall(String method) {
    return calledMethods$.firstWhere((element) => element == method);
  }

  Future<void> save() async {
    await controller.postMessage(RECEIVER_GAME_OBJECT, METHOD_SAVE, "");
    await waitForNextCall("SaveZone");
  }
}
