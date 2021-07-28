import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scout_spirit/src/error/app_error.dart';
import 'package:scout_spirit/src/models/inventory.dart';
import 'package:scout_spirit/src/models/rewards/reward.dart';
import 'package:scout_spirit/src/providers/logger.dart';
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

  Future<World> addZone(String worldId, String originNodeId,
      String destinyNodeId, Zone newZone) async {
    Box<World> box = await Hive.openBox<World>('world');
    World world = await getWorld(worldId);
    String originZoneId = world.currentZoneId;

    String newZoneId;
    do {
      newZoneId = uuid.Uuid().v1();
    } while (world.zones.containsKey(newZoneId));

    // add new zone to the world
    world.zones[newZoneId] = newZone;

    // set connection from origin to new zone
    Zone? originZone = world.zones[originZoneId];
    if (originZone == null) {
      throw new AppError(message: 'Unknown zone: "$originZoneId"');
    }
    originZone.nodes[originNodeId] = Node(zone: newZoneId, node: destinyNodeId);

    // set connection from new zone to origin
    if (!newZone.nodes.containsKey(destinyNodeId)) {
      throw new AppError(message: 'Unknown destiny node: "$destinyNodeId"');
    }
    newZone.nodes[destinyNodeId] = Node(zone: originZoneId, node: originNodeId);

    // set as current zone
    world.currentZoneId = newZoneId;
    world.currentNodeId = destinyNodeId;

    await box.put(worldId, world);
    return world;
  }

  World get initialWorld => World(zones: {
        "start": Zone(
            zoneId: "Base",
            lastJoinTime: null,
            objects: [],
            nodes: {"South": null, "North": null})
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

  Future<ZoneMeta> getZoneMeta(Zone zone) async {
    Map<String, dynamic> metaMap = json.decode(await rootBundle
        .loadString('assets/jsons/resources/zones/meta/${zone.zoneId}.json'));
    print(metaMap);
    ZoneMeta meta = ZoneMeta.fromMap(zone, metaMap);
    return meta;
  }

  Future<Zone> getDefaultZone(String zoneId) async {
    Map<String, dynamic> zone = json.decode(await rootBundle
        .loadString('assets/jsons/resources/zones/defaults/$zoneId.json'));
    return Zone.fromMap(zone);
  }

  Stream<List<ZoneMeta>> getAvailableZones() {
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
      List<ZoneMeta> zones = await Future.wait(count.map((zoneId) =>
          getDefaultZone(zoneId).then((value) => getZoneMeta(value))));
      return zones;
    });
  }

  Future<List<DecorationReward>> getAvailableItems(
      {bool subtract = false}) async {
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

  Future<Inventory> getInventory() async {
    String userId = AuthenticationService().authenticatedUserId;
    Box<Inventory> box = await Hive.openBox<Inventory>('inventory');
    Inventory? inventory = box.get(userId);
    if (inventory == null) {
      inventory = Inventory();
      await box.put(userId, inventory);
    }
    return inventory;
  }

  Future<void> updateInventory(Inventory inventory) async {
    await LoggerService()
        .log('WORLD_SERVICE', "Saving inventory: ${inventory.toMap()}");
    String userId = AuthenticationService().authenticatedUserId;
    Box<Inventory> box = await Hive.openBox<Inventory>('inventory');
    await box.put(userId, inventory);
  }

  Future<World> updateZone(String id, Zone zone) async {
    await LoggerService()
        .log('WORLD_SERVICE', "Saving zone with id $id: ${zone.toMap()}");
    String userId = AuthenticationService().authenticatedUserId;
    World world = await getWorld(userId);
    world.zones[id] = zone;

    await saveWorld(userId, world);
    await LoggerService().log('WORLD_SERVICE', "Saved world: ${world.toMap()}");
    return world;
  }
}
