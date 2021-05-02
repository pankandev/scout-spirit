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