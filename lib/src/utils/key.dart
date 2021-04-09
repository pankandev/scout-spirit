const String _SPLITTER = '::';

String joinKey(List<String> args) {
  return args.join(_SPLITTER);
}

List<String> splitKey(String args) {
  return args.split(_SPLITTER);
}
