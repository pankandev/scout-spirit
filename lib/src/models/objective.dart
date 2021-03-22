import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/utils/development_area.dart';
import 'package:scout_spirit/src/utils/development_stage.dart';

class Objective {
  final int line;
  final int subline;
  final DevelopmentStage stage;
  final DevelopmentArea area;
  final String rawObjective;

  Objective(
      {this.stage, this.area, this.line, this.subline, this.rawObjective});

  static Objective fromCode(String code) {
    List<String> sections = code.split('::');
    List<String> line = sections[2].split('.');
    return Objective(
        stage: stageFromName(sections[0]),
        area: areaFromName(sections[1]),
        line: int.parse(line[0]),
        subline: int.parse(line[1]),
        rawObjective: '');
  }

  String get authorizedObjective {
    User user = AuthenticationService().snapAuthenticatedUser;
    if (user == null) return rawObjective;
    return getUserObjective(user);
  }

  String get stageName {
    return stage.toString().split('.')[1].toLowerCase();
  }

  String get areaName {
    return area.toString().split('.')[1].toLowerCase();
  }

  String getUserObjective(User user) {
    return rawObjective
        .replaceAll("{OsAs}", user.unit == Unit.Guides ? "as" : "os")
        .replaceAll("{OA}", user.unit == Unit.Guides ? "a" : "o")
        .replaceAll("{GuiaScout}", user.unit == Unit.Guides ? "Guía" : "Scout")
        .replaceAll(
            "{Unidad}", user.unit == Unit.Guides ? "Compañía" : "Tropa");
  }

  @override
  String toString() {
    return "Objective(stage: $stage, area: $area, line: $line, subline: $subline, objective: '$authorizedObjective')";
  }

  Objective copyWith({String objective}) {
    return Objective(
        line: line,
        subline: subline,
        stage: stage,
        area: area,
        rawObjective: objective ?? rawObjective);
  }
}
