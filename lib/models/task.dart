import 'priority.dart';

abstract class Task {
  final String id;
  String title;
  Priority priority;
  DateTime? dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.dueDate,
    this.isCompleted = false,
  });

  bool get isUrgent;

  Map<String, dynamic> toJson();

  @override
  String toString() {
    final status = isCompleted ? '[✓]' : '[ ]';
    final dateStr = dueDate != null ? ' (Échéance: ${dueDate!.toLocal().toString().split(' ')[0]})' : '';
    return '$status $id | [$priorityName] $title$dateStr';
  }

  String get priorityName => priority.name.toUpperCase();
}