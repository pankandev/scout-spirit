import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scout_spirit/src/models/world.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/world.dart';
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
    controller.on('GetWorld', getWorld);
    controller.on('SaveZone', saveZone);

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

  Future<Map<String, dynamic>> getWorld(Map<String, dynamic>? arguments) async {
    String userId = AuthenticationService().authenticatedUserId;
    World world = await WorldService().getWorld(userId);
    print(world.toMap());
    return world.toMap();
  }

  Future<Map<String, dynamic>> saveZone(Map<String, dynamic> arguments) async {
    // Zone zone = Zone.fromMap(arguments!);

    String userId = AuthenticationService().authenticatedUserId;
    World world = await WorldService().getWorld(userId);

    return world.toMap();
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
