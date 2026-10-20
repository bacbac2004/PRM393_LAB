
class TaskItem {
  final int id;
  final String name;
  final String description;
  final bool completed;

  const TaskItem({
    required this.id,
    required this.name,
    required this.description,
    required this.completed,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'completed': completed,
  };

  TaskItem copyWith({
    int? id,
    String? name,
    String? description,
    bool? completed,
  }) {
    return TaskItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}
