
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/utils/development_area.dart';
import 'package:scout_spirit/src/utils/development_stage.dart';

class Line {
  final String name;
  final String? image;
  final Map<DevelopmentStage, List<Objective>> objectives;

  Line({required this.name, required this.objectives, this.image});

  @override
  String toString() {
    return "Line(name: '$name', image: $image, objectives: $objectives)";
  }
}

class Objective {
  final int line;
  final int subline;
  final DevelopmentStage stage;
  final DevelopmentArea area;
  final String rawObjective;

  Objective(
      {required this.stage,
      required this.area,
      required this.line,
      required this.subline,
      required this.rawObjective});

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
    User user = AuthenticationService().snapAuthenticatedUser!;
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
    return "Objective(stage: $stage, area: $area, line: $line, subline: $subline, objective: '$rawObjective')";
  }

  Objective copyWith({String? objective}) {
    return Objective(
        line: line,
        subline: subline,
        stage: stage,
        area: area,
        rawObjective: objective ?? rawObjective);
  }

  @override
  bool operator ==(Object other) {
    if (other is Objective) {
      return other.stage == stage &&
          other.area == area &&
          other.line == line &&
          other.subline == subline;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode;
}
