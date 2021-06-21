import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:scout_spirit/src/models/rewards/reward.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/rewards.dart';
import 'package:scout_spirit/src/utils/map.dart';
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
    List<String> nodes = zone.nodes.keys.toList();
    String startNode = nodes[new Random().nextInt(nodes.length)];
    world.currentZoneId = zoneId;
    world.currentNodeId = startNode;
    await box.put(id, world);
    return world;
  }

  World get initialWorld => World(zones: {
        "start": Zone(zoneId: "Base", lastJoinTime: null, objects: [
          ZoneObject(
              objectId: 'id',
              position: Vector3(5, 17, 10),
              rotation: Quaternion(0, 0, 0, 0),
              scale: Vector3(1, 1, 1))
        ], nodes: {
          "South": null,
          "North": null
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

  Future<Zone> getDefaultZone(String zoneId) async {
    Map<String, dynamic> zone = json
        .decode(await rootBundle.loadString('assets/jsons/resources/zones/$zoneId.json'));
    return Zone.fromMap(zone);
  }

  Stream<List<Zone>> getAvailableZones() {
    RewardsService().updateCategory('zone');
    return RewardsService()
        .getByCategory<ZoneReward>('zone')
        .asyncMap((rewards) async {
      World world = await getMyWorld();
      Iterable<String> filteredZones =
          world.zones.keys.where((element) => element != 'start');
      Iterable<String> worldZones =
          filteredZones.map((zoneKey) => world.zones[zoneKey]!.zoneId);
      Iterable<String> rewardZones = rewards.map((reward) => reward.zoneId);
      Map<String, int> worldCount = mapUtils.countMap(worldZones);
      Map<String, int> rewardCount = mapUtils.countMap(rewardZones);
      Map<String, int> availableCount = mapUtils.aggregateMap(
          (w, r) => (r ?? 0) - (w ?? 0), worldCount, rewardCount);
      List<String> count = mapUtils.fromCount(availableCount);
      List<Zone> zones =
          await Future.wait(count.map((zoneId) => getDefaultZone(zoneId)));
      return zones;
    });
  }

  Future<List<DecorationReward>> getAvailableItems({bool subtract = false}) async {
    await RewardsService().updateCategory('decoration');
    String userId = AuthenticationService().authenticatedUserId;
    List<DecorationReward> items =
        RewardsService().getSnapByCategory<DecorationReward>('decoration');
    LazyBox<List<String>> box =
        await Hive.openLazyBox<List<String>>('claimedItems');
    List<String> claimedItems = await box.get(userId) ?? [];
    List<DecorationReward> newItems = subtractList<DecorationReward, String>(
        items,
        claimedItems.map((e) => DecorationReward.dummyFromCode(e)),
        (item) => item.code).toList();
    if (subtract) {
      claimedItems.addAll(newItems.map((e) => e.code));
      box.put(userId, claimedItems);
      print("currently claimed: $claimedItems");
    }
    return newItems;
  }

  Future<World> updateZone(String id, Zone zone) async {
    String userId = AuthenticationService().authenticatedUserId;
    World world = await WorldService().getWorld(userId);
    world.zones[id] = zone;

    await WorldService().saveWorld(userId, world);
    return await WorldService().getWorld(userId);
  }
}
