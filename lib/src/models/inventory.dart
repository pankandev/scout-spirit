import 'package:hive/hive.dart';
import 'package:scout_spirit/src/utils/json.dart';

part 'inventory.g.dart';

@HiveType(typeId: 8)
class ItemQuantity {
  @HiveField(0)
  final String itemId;

  @HiveField(1)
  final int amount;

  const ItemQuantity(this.itemId, this.amount);

  ItemQuantity.fromMap(Map<String, dynamic> map)
      : itemId = JsonUtils.to<String>(map['itemId']) ?? '',
        amount = JsonUtils.to<int>(map['amount']) ?? 1;

  Map<String, dynamic> toMap() {
    return {"itemId": itemId, "amount": amount};
  }
}

@HiveType(typeId: 7)
class Inventory {
  @HiveField(0)
  final List<String?> hotbar;

  @HiveField(1)
  final List<ItemQuantity> items;

  Inventory({this.hotbar = const [], this.items = const []});

  Inventory.fromMap(Map<String, dynamic> map)
      : hotbar = List.from(map['hotbar'])
            .map((e) => JsonUtils.to<String>(e))
            .toList(),
        items = (JsonUtils.toList<Map>(map['items']) ?? [])
            .map((e) => ItemQuantity.fromMap(e.cast<String, dynamic>()))
            .toList();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "hotbar": hotbar.map((e) => e).toList(),
      "items": items.map((e) => e.toMap()).toList()
    };
  }
}
