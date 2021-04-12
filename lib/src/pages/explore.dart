import 'package:flutter/material.dart';
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
  }

  @override
  void dispose() {
    super.dispose();

    GameController controller = GameController();
    controller.off();
  }

  Future<Map<String, dynamic>?> onTestMethod(
      Map<String, dynamic>? arguments) async {
    return {"data": ":D"};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: UnityApp(controller: GameController()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => GameController().goToScene("World"),
      ),
    );
  }
}
