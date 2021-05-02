import 'package:scout_spirit/src/models/rewards/reward.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/rewards.dart';
import 'package:uuid/uuid.dart' as uuid;
import 'package:hive/hive.dart';
import 'package:scout_spirit/src/models/world.dart';
import 'package:scout_spirit/src/utils/map.dart' as mapUtils;

class WorldService {
  static WorldService _instance = WorldService._internal();

  WorldService._internal();

  factory WorldService() {
    return _instance;
  }

  Future<void> saveWorld(String id, World world) async {
    Box<World> box = await Hive.openBox<World>('world');
    await box.put(id, world);
  }

  Future<World> addZone(String id, Zone zone) async {
    Box<World> box = await Hive.openBox<World>('world');
    World world = await getWorld(id);

    String zoneId;
    do {
      zoneId = uuid.Uuid().v1();
    } while (world.zones.containsKey(zoneId));

    world.zones[zoneId] = zone;
    await box.put(id, world);
    return world;
  }

  World get initialWorld => World(zones: {
        "start": Zone(zoneId: "Base", lastJoinTime: null, objects: [], nodes: {
          "South": Node(zone: "start", node: "North"),
          "North": Node(zone: "start", node: "South")
        })
      }, currentZoneId: "start", currentNodeId: "South");

  Future<World> getWorld(String id) async {
    Box<World> box = await Hive.openBox<World>('world');
    World? world = box.get(id);
    if (world == null) {
      world = initialWorld;
      await box.put(id, world);
    }
    return world;
  }

  Future<World> getMyWorld() async {
    return await getWorld(AuthenticationService().authenticatedUserId);
  }

  Stream<List<Zone>> getAvailableZones() {
    return RewardsService()
        .getByCategory<ZoneReward>('zone')
        .asyncMap((rewards) async {
      World world = await getMyWorld();
      Iterable<String> worldZones = world.zones.values.map((e) => e.zoneId);
      Iterable<String> rewardZones = rewards.map((reward) => reward.zoneId);
      Map<String, int> worldCount = mapUtils.countMap(worldZones);
      Map<String, int> rewardCount = mapUtils.countMap(rewardZones);
      Map<String, int> availableCount = mapUtils.aggregateMap(
          (w, r) => (r ?? 0) - (w ?? 0), worldCount, rewardCount);
      return mapUtils
          .fromCount(availableCount)
          .map((zoneId) => new Zone(
              zoneId: zoneId, objects: [], lastJoinTime: null, nodes: {}))
          .toList();
    });
  }
}
