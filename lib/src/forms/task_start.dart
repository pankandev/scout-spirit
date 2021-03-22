import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/models/task.dart';

class TaskStartFormState {
  final Objective originalObjective;
  final Objective personalObjective;
  final List<Task> tasks;

  TaskStartFormState(
      {this.originalObjective, this.personalObjective, this.tasks});
}

class TaskStartForm {
  final BehaviorSubject<Objective> _original = BehaviorSubject<Objective>();
  final BehaviorSubject<Objective> _personal = BehaviorSubject<Objective>();

  final BehaviorSubject<List<Task>> _tasks = BehaviorSubject<List<Task>>();

  List<Task> get tasks => _tasks.value;

  set tasks(List<Task> value) {
    _tasks.sink.add(value);
  }

  TaskStartForm() {
    _original.value = null;
    _personal.value = null;
    _tasks.value = [];
  }

  Stream<TaskStartFormState> get stateStream => CombineLatestStream.combine3<
              Objective, Objective, List<Task>, TaskStartFormState>(
          originalObjectiveStream, personalObjectiveStream, tasksStream,
          (original, personal, tasks) {
        return TaskStartFormState(
            originalObjective: original,
            personalObjective: personal,
            tasks: tasks);
      });

  set originalObjective(Objective value) {
    _original.sink.add(value);
  }

  Objective get originalObjective => _original.value;

  Stream<Objective> get originalObjectiveStream => _original.stream;

  set personalObjective(Objective value) {
    _personal.sink.add(value);
  }

  Objective get personalObjective => _personal.value;

  Stream<Objective> get personalObjectiveStream =>
      _personal.stream.transform(_validateObjective);

  Stream<List<Task>> get tasksStream => _tasks.stream.transform(_validateTasks);

  final StreamTransformer<Objective, Objective> _validateObjective =
      StreamTransformer<Objective, Objective>.fromHandlers(
          handleData: (data, sink) {
    if (data.rawObjective.isNotEmpty) {
      sink.add(data);
    } else {
      sink.addError('Objetivo está vacío');
    }
  });

  final StreamTransformer<List<Task>, List<Task>> _validateTasks =
      StreamTransformer<List<Task>, List<Task>>.fromHandlers(
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
    _original.value = null;
    _personal.value = null;
    _tasks.value = [];
  }
}
