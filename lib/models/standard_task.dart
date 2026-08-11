import 'task.dart';
import 'priority.dart';

class StandardTask extends Task {
  StandardTask({
    required super.id,
    required super.title,
    super.priority = Priority.medium,
    super.dueDate,
    super.isCompleted,
  });

  @override
  bool get isUrgent => priority == Priority.high;

  @override
  Map<String, dynamic> toJson() => {
        'type': 'standard',
        'id': id,
        'title': title,
        'priority': priority.name,
        'dueDate': dueDate?.toIso8601String(),
        'isCompleted': isCompleted,
      };

  factory StandardTask.fromJson(Map<String, dynamic> json) {
    return StandardTask(
      id: json['id'] as String,
      title: json['title'] as String,
      priority: Priority.parse(json['priority'] as String),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}