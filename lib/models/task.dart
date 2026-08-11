import 'priority.dart';
import 'standard_task.dart';
import 'urgent_task.dart';

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

  /// Désérialise une tâche depuis son JSON selon son champ `type`.
  /// `standard` produit une [StandardTask], `urgent` une [UrgentTask].
  factory Task.fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'urgent') {
      return UrgentTask.fromJson(json);
    }
    return StandardTask.fromJson(json);
  }

  // Méthode abstraite pour déterminer l'urgence métier
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