class SubTask {
  final String description;
  final bool completed;

  SubTask({required this.description, this.completed = false});

  @override
  String toString() {
    return "SubTask(description: '$description', completed: $completed)";
  }

  Map<String, dynamic> toMap() {
    return {
      "description": description,
      "completed": completed
    };
  }
}