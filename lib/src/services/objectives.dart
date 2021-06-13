import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scout_spirit/src/error/app_error.dart';
import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/utils/development_stage.dart';
import 'package:scout_spirit/src/utils/development_area.dart';

class ObjectivesService {
  static final ObjectivesService _instance = ObjectivesService._internal();

  factory ObjectivesService() {
    return _instance;
  }

  ObjectivesService._internal();

  Map<DevelopmentArea, List<Line>>? cache;

  bool get initialized => cache != null;

  Future<void> preload() async {
    String linesData =
        await rootBundle.loadString('assets/jsons/resources/lines.json');
    Map<String, dynamic> lines = json.decode(linesData);

    Map<DevelopmentArea, List<Line>> newCache = cache = {};
    lines.keys.forEach((areaName) {
      DevelopmentArea area = areaFromName(areaName);
      List<Map<String, dynamic>> areaLines = (lines[areaName] as List).cast<Map<String, dynamic>>();
      List<Line> thisLines = areaLines
          .asMap()
          .keys
          .map<Line>((index) => Line(
              index: index, name: areaLines[index]["name"], objectives: {}))
          .toList();
      thisLines.sort((a, b) => a.index - b.index);
      newCache[area] = thisLines;
    });

    await Future.wait(
        DevelopmentStage.values.map((DevelopmentStage stage) async {
      // iterate stages
      String data = await rootBundle.loadString(
          'assets/jsons/resources/objectives/${stageToString(stage)}.json');
      Map<String, dynamic> stageLines = json.decode(data);
      stageLines.forEach((String areaName, dynamic lines) {
        // iterate areas
        DevelopmentArea area = areaFromName(areaName);
        lines.asMap().forEach((int lineIndex, dynamic objectives) {
          // iterate lines
          List<Objective> cacheObjectives =
              newCache[area]![lineIndex].objectives[stage] = [];
          List.castFrom<dynamic, String>(List.from(objectives))
              .asMap()
              .forEach((sublineIndex, String objectiveContent) {
            // iterate sub-lines
            Objective objective = Objective(
                stage: stage,
                area: area,
                line: lineIndex + 1,
                subline: sublineIndex + 1,
                rawObjective: objectiveContent);
            cacheObjectives.add(objective);
          });
        });
      });
    }));
  }

  List<Objective> getAllByStage(DevelopmentStage stage) {
    if (!initialized)
      throw AppError(message: 'Trying to use uninitialized service');
    Map<DevelopmentArea, List<Line>> lines = cache!;
    List<Objective> objectives = lines.keys
        .map<Iterable<Objective>>((area) => lines[area]!
            .map((l) => l.objectives[stage]!)
            .expand<Objective>((l) => l))
        .expand((l) => l)
        .toList();
    objectives.sort((a, b) => a.area.index - b.area.index);
    return objectives;
  }

  Map<DevelopmentArea, List<Line>> groupObjectives(List<Objective> objectives) {
    Map<DevelopmentArea, List<Line>> grouped = {};
    for (Objective objective in objectives) {
      List<Line> areaGroup = grouped[objective.area] ?? [];
      grouped[objective.area] = areaGroup;

      Line lineGroup = areaGroup.firstWhere(
          (element) => element.index == objective.line - 1, orElse: () {
        Line line = getLine(objective.area, objective.line);
        Line newLine = Line(index: line.index, name: line.name, objectives: {
          DevelopmentStage.Prepuberty: [],
          DevelopmentStage.Puberty: []
        });
        areaGroup.add(newLine);
        return newLine;
      });
      lineGroup.objectives[objective.stage]!.add(objective);
    }
    return grouped;
  }

  List<Objective> getAllByArea(DevelopmentStage stage, DevelopmentArea area) {
    if (!initialized)
      throw AppError(message: 'Trying to use uninitialized service');
    Map<DevelopmentArea, List<Line>> lines = cache!;
    return lines[area]!
        .map((l) => l.objectives[stage]!)
        .expand<Objective>((l) => l)
        .toList();
  }

  Line getLine(DevelopmentArea area, int line) {
    if (!initialized)
      throw AppError(message: 'Trying to use uninitialized service');
    Map<DevelopmentArea, List<Line>> lines = cache!;
    return lines[area]![line - 1];
  }

  List<Line> getAllLinesByArea(DevelopmentArea area) {
    if (!initialized)
      throw AppError(message: 'Trying to use uninitialized service');
    Map<DevelopmentArea, List<Line>> lines = cache!;
    return lines[area]!;
  }

  List<Objective> getAllByLine(
      DevelopmentStage stage, DevelopmentArea area, int line) {
    if (!initialized)
      throw AppError(message: 'Trying to use uninitialized service');
    return getLine(area, line).objectives[stage] ?? [];
  }

  Objective getBySubline(
      DevelopmentStage stage, DevelopmentArea area, int line, int subline) {
    if (!initialized)
      throw AppError(message: 'Trying to use uninitialized service');
    return this.getAllByLine(stage, area, line)[subline - 1];
  }

  Objective getByKey(String key) {
    List<String> splitted = key.split('::');
    if (splitted.length != 3)
      throw new AppError(message: 'Objective key $key must consist of 3 parts');
    List<String> lineSubline = splitted[2].split('.');
    if (lineSubline.length != 2)
      throw new AppError(
          message: 'Objective line ${splitted[2]} must consist of 2 parts');
    DevelopmentStage stage = stageFromName(splitted[0]);
    DevelopmentArea area = areaFromName(splitted[1]);
    int line = int.parse(lineSubline[0]);
    int subline = int.parse(lineSubline[1]);
    return getBySubline(stage, area, line, subline);
  }
}
