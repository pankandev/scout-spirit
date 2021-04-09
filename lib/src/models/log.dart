class Log {
  final String tag;
  final DateTime time;
  final String log;
  final Map<String, dynamic>? data;

  Log.fromMap(Map<String, dynamic?> map):
      tag = map["tag"]!,
      time = new DateTime.fromMillisecondsSinceEpoch(map["timestamp"] as int, isUtc: true).toLocal(),
      log = map["log"],
      data = map["data"];

  @override
  String toString() {
    return "Log(tag: $tag, time: $time, log: $log, data: $data)";
  }
}