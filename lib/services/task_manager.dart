import '../exceptions/task_exceptions.dart';
import '../models/priority.dart';
import '../models/standard_task.dart';
import '../models/task.dart';
import '../models/urgent_task.dart';
import '../repositories/repository_interface.dart';

enum SortStrategy { priority, dueDate }

class TaskManager {
  final Repository<Task> repository;

  TaskManager(this.repository);

  Future<Task> addTask({
    required String title,
    Priority priority = Priority.medium,
    DateTime? dueDate,
    String? urgencyReason,
  }) async {
    if (title.trim().isEmpty) {
      throw InvalidTaskDataException('Le titre ne peut pas être vide.');
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString().substring(7);

    final Task task = (urgencyReason != null && urgencyReason.trim().isNotEmpty)
        ? UrgentTask(id: id, title: title, urgencyReason: urgencyReason, dueDate: dueDate)
        : StandardTask(id: id, title: title, priority: priority, dueDate: dueDate);

    await repository.save(task);
    return task;
  }

  Future<List<Task>> listTasks({SortStrategy sort = SortStrategy.priority}) async {
    final tasks = await repository.getAll();

    if (sort == SortStrategy.priority) {
      tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    } else {
      tasks.sort((a, b) {
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      });
    }

    return tasks;
  }

  Future<void> completeTask(String id) async {
    final task = await repository.getById(id);
    if (task == null) throw TaskNotFoundException(id);

    task.isCompleted = true;
    await repository.update(task);
  }

  Future<void> removeTask(String id) async {
    await repository.delete(id);
  }
}