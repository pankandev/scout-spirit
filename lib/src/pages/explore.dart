import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scout_spirit/src/models/avatar.dart';
import 'package:scout_spirit/src/models/rewards/reward.dart';
import 'package:scout_spirit/src/models/world.dart';
import 'package:scout_spirit/src/providers/snackbar.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/avatar.dart';
import 'package:scout_spirit/src/services/world.dart';
import 'package:scout_spirit/src/unity/unity_controller.dart';
import 'package:scout_spirit/src/utils/json.dart';
import 'package:scout_spirit/src/widgets/unity_app.dart';
import 'package:scout_spirit/src/pages/new_zone.dart';
import 'package:uuid/uuid.dart' as uuid;

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
    controller.on('getAvatar', getAvatar);
    controller.on('SaveZone', saveZone);
    controller.on('AddNewZone', addNewZone);
    controller.on('RequestItem', requestItem);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  @override
  void dispose() {
    super.dispose();

    GameController controller = GameController();
    controller.off();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
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
    return world.toMap();
  }

  Future<Map<String, dynamic>> getAvatar(
      Map<String, dynamic>? arguments) async {
    Avatar avatar = await AvatarService().getAuthenticatedAvatar();
    return avatar.toMap();
  }

  Future<Map<String, dynamic>> saveZone(Map<String, dynamic> arguments) async {
    String id = arguments['id'];
    Zone zone = Zone.fromMap(arguments['zone']);

    World world = await WorldService().updateZone(id, zone);
    return world.toMap();
  }

  @override
  Widget build(BuildContext context) {
    GameController controller = GameController();
    return WillPopScope(
      onWillPop: () async {
        controller.pause();
        bool result = await SnackBarProvider.showConfirmAlert(
          context, 'Seguro que quieres salir?',
          okLabel: 'Salir 🚪');
        await Future.delayed(Duration(seconds: 1));
        controller.resume();
        return result;
      },
      child: Scaffold(
          body: UnityApp(
        controller: GameController(),
        initialSceneName: "Videogame",
        fullscreen: true,
      )),
    );
  }

  Future<Map<String, dynamic>?> requestItem(
      Map<String, dynamic>? arguments) async {
    List<DecorationReward> items = await WorldService().getAvailableItems(subtract: JsonUtils.to<bool>((arguments ?? {})['subtract']) ?? true);
    List<String> itemsIds = items.map((e) => e.code).toList();
    return {'items': itemsIds};
  }

  Future<Map<String, dynamic>?> addNewZone(
      Map<String, dynamic> arguments) async {
    await Future.delayed(Duration(seconds: 1));
    await GameController().pause();
    Zone? newZone = await showDialog<Zone>(
        context: context, builder: (_) => NewZoneDialog());
    await GameController().resume();
    if (newZone == null || !(newZone is Zone)) {
      return null;
    }
    String id = uuid.Uuid().v4();
    World newWorld = await WorldService().addZone(id, newZone);
    return newWorld.toMap();
  }
}
