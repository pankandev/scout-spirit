import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scout_spirit/src/unity/unity_controller.dart';
import 'package:scout_spirit/src/widgets/unity_app.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  void initState() {
    super.initState();

    GameController controller = GameController();
    controller.on("test", onTestMethod);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    super.dispose();

    GameController controller = GameController();
    controller.off();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<Map<String, dynamic>?> onTestMethod(
      Map<String, dynamic>? arguments) async {
    return {"data": ":D"};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: UnityApp(
          controller: GameController(),
          initialSceneName: "Videogame",
          fullscreen: true,
        ));
  }
}
