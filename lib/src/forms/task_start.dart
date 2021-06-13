import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/models/task.dart';

class TaskStartFormState {
  final Objective? originalObjective;
  final Objective? personalObjective;
  final List<SubTask>? tasks;

  TaskStartFormState(
      {required this.originalObjective,
      required this.personalObjective,
      required this.tasks});
}

class TaskStartForm {
  final BehaviorSubject<Objective?> _original = BehaviorSubject<Objective?>();
  final BehaviorSubject<Objective?> _personal = BehaviorSubject<Objective?>();

  final BehaviorSubject<List<SubTask>> _tasks =
      BehaviorSubject<List<SubTask>>();

  List<SubTask> get tasks => _tasks.value;

  set tasks(List<SubTask> value) {
    _tasks.add(value);
  }

  TaskStartForm() {
    _original.add(null);
    _personal.add(null);
    _tasks.add([]);
  }

  Stream<TaskStartFormState> get stateStream => CombineLatestStream.combine3<
              Objective?, Objective, List<SubTask>, TaskStartFormState>(
          originalObjectiveStream, personalObjectiveStream, tasksStream,
          (original, personal, tasks) {
        return TaskStartFormState(
            originalObjective: original,
            personalObjective: personal,
            tasks: tasks);
      });

  set originalObjective(Objective? value) {
    _original.sink.add(value);
  }

  Objective? get originalObjective => _original.value;

  Stream<Objective?> get originalObjectiveStream => _original.stream;

  set personalObjective(Objective? value) {
    _personal.add(value);
  }

  Objective? get personalObjective => _personal.value;

  Stream<Objective> get personalObjectiveStream => _personal.stream
      .where((event) => event != null)
      .map((event) => event as Objective);

  Stream<List<SubTask>> get tasksStream =>
      _tasks.stream.transform(_validateTasks);

  final StreamTransformer<List<SubTask>, List<SubTask>> _validateTasks =
      StreamTransformer<List<SubTask>, List<SubTask>>.fromHandlers(
          handleData: (data, sink) {
    bool isAnyObjectiveEmpty = data.fold(true,
        (previousValue, element) => previousValue && element.description == '');
    if (data.length > 0) {
      if (isAnyObjectiveEmpty) {
        sink.addError('Una tarea está vacía');
      } else {
        sink.add(data);
      }
    } else {
      sink.addError('La lista de tareas está vacía');
    }
  });

  void dispose() {
    _original.close();
    _personal.close();
    _tasks.close();
  }

  void clear() {
    _original.add(null);
    _personal.add(null);
    _tasks.add([]);
  }
}
