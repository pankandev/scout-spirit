import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scout_spirit/src/utils/datetime.dart';

class LogDisplay {
  final String name;
  final IconData icon;
  final String Function(Log log) getLog;

  LogDisplay({required this.name, required this.icon, required this.getLog});
}

Map<String, LogDisplay> tagsDisplay = {
  'PROGRESS': LogDisplay(
      name: 'Registro',
      icon: Icons.edit,
      getLog: (log) => 'Realizó un registro'),
  'REWARD': LogDisplay(
      name: 'Recompensa',
      icon: Icons.favorite_border,
      getLog: (log) => 'Ganó una recompensa'),
};

class Log {
  final String tag;
  final DateTime time;
  final String log;
  final Map<String, dynamic>? data;

  LogDisplay get display =>
      tagsDisplay[parentTag] ??
      LogDisplay(
          name: 'Registro desconocido', icon: Icons.help, getLog: (log) => 'Registro desconocido');

  String get displayLog => display.getLog(this);

  Log.fromMap(Map<String, dynamic?> map)
      : tag = map["tag"]!,
        time = new DateTime.fromMillisecondsSinceEpoch(map["timestamp"] as int,
                isUtc: true)
            .toLocal(),
        log = map["log"],
        data = map["data"];

  @override
  String toString() {
    return "Log(tag: $tag, time: $time, log: $log, data: $data)";
  }

  String get parentTag {
    return tag.toUpperCase().split('::').first;
  }

  String get timestampLabel {
    return dateTimeToString(time.toLocal());
  }
}
