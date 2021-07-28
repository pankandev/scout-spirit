import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scout_spirit/src/models/avatar.dart';
import 'package:scout_spirit/src/models/inventory.dart';
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
    controller.on('GetInventory', getInventory);
    controller.on('RequestItem', requestItem);
    if (kDebugMode) {
      controller.on('ShowToast', showToast);
    }

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

    // save inventory
    Inventory inventory = Inventory.fromMap(arguments['inventory']);
    await WorldService().updateInventory(inventory);

    // save zone
    Zone zone = Zone.fromMap(arguments['zone']);
    zone.lastJoinTime = DateTime.now().millisecondsSinceEpoch;
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
            context, '¿Seguro que quieres salir?',
            okLabel: 'Salir 🚪', waitFor: controller.save().then((_) => true));
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

  Future<Map<String, dynamic>?> showToast(
      Map<String, dynamic> arguments) async {
    String tag = arguments['TAG'];
    String message = arguments['ARGUMENTS'];
    SnackBarProvider.showMessage(context, "[$tag] $message");
  }

  Future<Map<String, dynamic>?> requestItem(
      Map<String, dynamic>? arguments) async {
    List<DecorationReward> items = await WorldService().getAvailableItems(
        subtract: JsonUtils.to<bool>((arguments ?? {})['subtract']) ?? true);
    List<String> itemsIds = items.map((e) => e.code).toList();
    return {'items': itemsIds};
  }

  Future<Map<String, dynamic>?> addNewZone(
      Map<String, dynamic> arguments) async {
    await Future.delayed(Duration(seconds: 1));
    await GameController().pause();
    Object? newZone =
        await showDialog(context: context, builder: (_) => NewZoneDialog());
    await GameController().resume();
    if (newZone == null || !(newZone is ZoneConnection)) {
      return null;
    }
    String originNodeId = arguments['originNode'];
    World newWorld = await WorldService().addZone(
        AuthenticationService().authenticatedUserId,
        originNodeId,
        newZone.nodeId,
        newZone.zone);
    return newWorld.toMap();
  }

  Future<Map<String, dynamic>> getInventory(dynamic _) async {
    Inventory inventory = await WorldService().getInventory();
    return inventory.toMap();
  }
}
