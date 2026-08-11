import 'task.dart';
import 'priority.dart';

class UrgentTask extends Task {
  final String urgencyReason;

  UrgentTask({
    required super.id,
    required super.title,
    required this.urgencyReason,
    super.dueDate,
    super.isCompleted,
  }) : super(priority: Priority.high);

  @override
  bool get isUrgent => true;

  @override
  Map<String, dynamic> toJson() => {
        'type': 'urgent',
        'id': id,
        'title': title,
        'priority': priority.name,
        'urgencyReason': urgencyReason,
        'dueDate': dueDate?.toIso8601String(),
        'isCompleted': isCompleted,
      };

  factory UrgentTask.fromJson(Map<String, dynamic> json) {
    return UrgentTask(
      id: json['id'] as String,
      title: json['title'] as String,
      urgencyReason: json['urgencyReason'] as String? ?? 'Non spécifié',
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    return '${super.toString()} [Motif: $urgencyReason]';
  }
}