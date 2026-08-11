import 'dart:io';

import 'package:task_cli/exceptions/task_exceptions.dart';
import 'package:task_cli/models/priority.dart';
import 'package:task_cli/models/standard_task.dart';
import 'package:task_cli/models/urgent_task.dart';
import 'package:task_cli/repositories/json_task_repository.dart';
import 'package:task_cli/services/task_manager.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;
  late TaskManager manager;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('task_manager_test');
    manager = TaskManager(JsonTaskRepository('${tempDir.path}/tasks.json'));
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  group('TaskManager.addTask', () {
    test('ajoute une tâche standard avec les valeurs fournies', () async {
      final task = await manager.addTask(
        title: 'Préparer le cours',
        priority: Priority.high,
        dueDate: DateTime(2026, 8, 20),
      );

      expect(task, isA<StandardTask>());
      expect(task.title, 'Préparer le cours');
      expect(task.priority, Priority.high);
      expect(task.dueDate, DateTime(2026, 8, 20));
      expect(task.isCompleted, isFalse);
      expect(task.id, isNotEmpty);
    });

    test('ajoute une tâche urgente quand un motif est fourni', () async {
      final task = await manager.addTask(
        title: 'Incident prod',
        urgencyReason: 'API indisponible',
      );

      expect(task, isA<UrgentTask>());
      expect((task as UrgentTask).urgencyReason, 'API indisponible');
      expect(task.priority, Priority.high);
      expect(task.isUrgent, isTrue);
    });

    test('lève InvalidTaskDataException pour un titre vide', () {
      expect(
        () => manager.addTask(title: '   '),
        throwsA(isA<InvalidTaskDataException>()),
      );
    });

    test('génère des identifiants uniques consécutifs', () async {
      final a = await manager.addTask(title: 'A');
      final b = await manager.addTask(title: 'B');
      expect(a.id, isNot(b.id));
    });
  });

  group('TaskManager.listTasks', () {
    test('trie par priorité décroissante', () async {
      await manager.addTask(title: 'Basse', priority: Priority.low);
      await manager.addTask(title: 'Haute', priority: Priority.high);
      await manager.addTask(title: 'Moyenne');

      final tasks = await manager.listTasks(sort: SortStrategy.priority);

      expect(tasks.map((t) => t.title), ['Haute', 'Moyenne', 'Basse']);
    });

    test('trie par date d\'échéance, les sans date en dernier', () async {
      await manager.addTask(title: 'Sans date');
      await manager.addTask(
        title: 'Plus tard',
        dueDate: DateTime(2026, 9, 1),
      );
      await manager.addTask(
        title: 'Bientôt',
        dueDate: DateTime(2026, 8, 12),
      );

      final tasks = await manager.listTasks(sort: SortStrategy.dueDate);

      expect(tasks.map((t) => t.title), ['Bientôt', 'Plus tard', 'Sans date']);
    });

    test('retourne une liste vide quand aucun enregistrement', () async {
      expect(await manager.listTasks(), isEmpty);
    });
  });

  group('TaskManager.completeTask', () {
    test('marque la tâche comme terminée', () async {
      final task = await manager.addTask(title: 'À terminer');

      await manager.completeTask(task.id);

      final loaded = (await manager.listTasks()).single;
      expect(loaded.isCompleted, isTrue);
    });

    test('lève TaskNotFoundException pour un id inconnu', () {
      expect(
        () => manager.completeTask('absent'),
        throwsA(isA<TaskNotFoundException>()),
      );
    });
  });

  group('TaskManager.removeTask', () {
    test('supprime la tâche', () async {
      final task = await manager.addTask(title: 'À supprimer');

      await manager.removeTask(task.id);

      expect(await manager.listTasks(), isEmpty);
    });

    test('lève TaskNotFoundException pour un id inconnu', () {
      expect(
        () => manager.removeTask('absent'),
        throwsA(isA<TaskNotFoundException>()),
      );
    });
  });

  group('TaskManager persistance', () {
    test('retrouve les tâches d\'une exécution précédente', () async {
      await manager.addTask(title: 'Persistée');

      final reloaded = TaskManager(
        JsonTaskRepository('${tempDir.path}/tasks.json'),
      );

      final tasks = await reloaded.listTasks();
      expect(tasks.single.title, 'Persistée');
    });
  });
}
