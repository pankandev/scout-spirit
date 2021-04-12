import 'package:rxdart/rxdart.dart';
import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/utils/development_area.dart';

class InitializeFormBloc {
  final BehaviorSubject<Map<DevelopmentArea, List<Objective>>>
      _selectedObjectives =
      BehaviorSubject<Map<DevelopmentArea, List<Objective>>>();

  Stream<Map<DevelopmentArea, List<Objective>>> get selectedObjectivesStream =>
      _selectedObjectives.stream;

  InitializeFormBloc() {
    _selectedObjectives.sink.add({});
  }

  Map<DevelopmentArea, List<Objective>> get value => _selectedObjectives.value!;
  set value(Map<DevelopmentArea, List<Objective>> newValue) {
    _selectedObjectives.sink.add(newValue);
  }

  addObjective(Objective objective) {
    Map<DevelopmentArea, List<Objective>> value = _selectedObjectives.value!;
    if (!value.containsKey(objective.area)) {
      value[objective.area] = [];
    }
    value[objective.area]!.add(objective);
    _selectedObjectives.sink.add(value);
  }

  int removeObjective(Objective objective) {
    Map<DevelopmentArea, List<Objective>> value = _selectedObjectives.value!;
    int found = findObjective(objective);
    if (found != -1) {
      value[objective.area]!.removeAt(found);
      _selectedObjectives.sink.add(value);
    }
    return found;
  }

  int findObjective(Objective objective) {
    Map<DevelopmentArea, List<Objective>> value = _selectedObjectives.value!;
    if (!value.containsKey(objective.area)) {
      return -1;
    }
    int found = value[objective.area]!.indexWhere((obj) =>
        obj.line == objective.line &&
        obj.subline == objective.subline &&
        obj.area == objective.area);
    return found;
  }

  void addObjectives(List<Objective> objectives) {
    objectives.forEach((objective) => addObjective(objective));
  }

  void setAreaObjectives(DevelopmentArea area, List<Objective> objectives) {
    Map<DevelopmentArea, List<Objective>> old = value;
    old[area] = [];
    objectives.forEach((objective) => addObjective(objective));
    value = old;
  }

  void toggleObjective(Objective objective) {
    if (removeObjective(objective) == -1) {
      addObjective(objective);
    }
  }

  bool initializeArea(DevelopmentArea area) {
    Map<DevelopmentArea, List<Objective>> value = _selectedObjectives.value!;
    if (!value.containsKey(area)) {
      value[area] = [];
      _selectedObjectives.sink.add(value);
      return true;
    }
    return false;
  }

  void resetArea(DevelopmentArea area) {
    Map<DevelopmentArea, List<Objective>> value = _selectedObjectives.value!;
    value.remove(area);
    _selectedObjectives.sink.add(value);
  }

  void dispose() {
    _selectedObjectives.close();
  }
}
