Map<T, int> countMap<T>(Iterable<T> items) {
  return items.fold(<T, int>{}, (value, element) {
    int? currentCount = value[element];
    if (currentCount == null) {
      currentCount = 0;
    }
    value[element] = currentCount + 1;
    return value;
  });
}

Map<TK, TV> aggregateMap<TK, TV>(
    TV Function(TV?, TV?) transform, Map<TK, TV> a, Map<TK, TV> b) {
  Set<TK> keys = a.keys.toSet();
  keys.addAll(b.keys);
  return new Map.fromEntries(
      keys.map((key) => new MapEntry(key, transform(a[key], b[key]))));
}

List<T> fromCount<T>(Map<T, int> count) {
  List<T> result = <T>[];
  count.forEach((key, value) {
    for (int i = 0; i < value; i++) {
      result.add(key);
    }
  });
  return result;
}

Iterable<T> subtractList<T, TC>(
    Iterable<T> a, Iterable<T> b, TC Function(T)? compareFun) {
  if (compareFun == null) {
    compareFun = ((el) {
      return el as TC;
    });
  }
  List<T> allItems = a.toList();
  allItems.addAll(b);
  Map<TC, T> ids = Map.fromEntries(
      allItems.map((value) => MapEntry<TC, T>(compareFun!(value), value)));

  Iterable<TC> aIds = a.map(compareFun);
  Iterable<TC> bIds = b.map(compareFun);
  Map<TC, int> aCount = countMap(aIds);
  Map<TC, int> bCount = countMap(bIds);
  Map<TC, int> availableCount =
      aggregateMap((w, r) => (r ?? 0) - (w ?? 0), aCount, bCount);
  List<TC> count = fromCount(availableCount);
  return count.map((e) => ids[e]!).toList();
}
