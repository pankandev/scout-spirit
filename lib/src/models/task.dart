class Task {
  final String description;
  final bool completed;

  Task({this.description, this.completed = false});

  @override
  String toString() {
    return "Task(description: '$description', completed: $completed)";
  }
}