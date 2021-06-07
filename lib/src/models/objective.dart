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

class ObjectiveKey {
  final int line;
  final int subline;
  final DevelopmentStage stage;
  final DevelopmentArea area;

  ObjectiveKey(
      {required this.line,
      required this.subline,
      required this.stage,
      required this.area});

  String get stageName {
    return stage.toString().split('.')[1].toLowerCase();
  }

  String get areaName {
    return area.toString().split('.')[1].toLowerCase();
  }
}

class Objective extends ObjectiveKey {
  final String rawObjective;

  Objective(
      {required DevelopmentStage stage,
      required DevelopmentArea area,
      required int line,
      required int subline,
      required this.rawObjective})
      : super(stage: stage, area: area, line: line, subline: subline);

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

  String getUserObjective(User user) {
    Unit unit = user.unit;
    return rawObjective
        .replaceAll("{OsAs}", unit == Unit.Guides ? 'as' : 'os')
        .replaceAll("{OA}", unit == Unit.Guides ? 'a' : 'o')
        .replaceAll("{GuiaScout}", unit == Unit.Guides ? 'Guía' : 'Scout')
        .replaceAll("{GuiasScouts}", unit == Unit.Guides ? 'Guías' : 'Scouts')
        .replaceAll("{Unidad}", unit == Unit.Guides ? 'Compañía' : 'Tropa')
        .replaceAll("{MyGender}", unit == Unit.Guides ? 'mujer' : 'hombre')
        .replaceAll("{OtherGender}", unit == Unit.Guides ? 'hombre' : 'mujer');
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
