import 'dart:io';

import 'package:task_cli/exceptions/task_exceptions.dart';
import 'package:task_cli/models/priority.dart';
import 'package:task_cli/models/task.dart';
import 'package:task_cli/repositories/json_task_repository.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;
  late JsonTaskRepository repo;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('task_cli_test');
    repo = JsonTaskRepository('${tempDir.path}/tasks.json');
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  group('JsonTaskRepository', () {
    test('crée automatiquement le fichier s\'il n\'existe pas', () async {
      final tasks = await repo.getAll();
      expect(tasks, isEmpty);
      expect(File('${tempDir.path}/tasks.json').existsSync(), isTrue);
    });

    test('sauvegarde et relit une tâche standard', () async {
      final task = Task.fromJson({
        'type': 'standard',
        'id': 'a1',
        'title': 'Écrire le rapport',
        'priority': 'high',
        'dueDate': null,
        'isCompleted': false,
      });

      await repo.save(task);

      final loaded = await repo.getById('a1');
      expect(loaded, isNotNull);
      expect(loaded!.title, 'Écrire le rapport');
      expect(loaded.priority, Priority.high);
    });

    test('sauvegarde et relit une tâche urgente', () async {
      await repo.save(
        UrgentTaskHelper.urgent(),
      );

      final loaded = await repo.getById('u1');
      expect(loaded, isNotNull);
      expect(loaded!.isUrgent, isTrue);
    });

    test('getById retourne null pour un identifiant inconnu', () async {
      final result = await repo.getById('inconnu');
      expect(result, isNull);
    });

    test('met à jour une tâche existante', () async {
      final task = Task.fromJson({
        'type': 'standard',
        'id': 'a1',
        'title': 'Initial',
        'priority': 'low',
        'dueDate': null,
        'isCompleted': false,
      });
      await repo.save(task);

      task.title = 'Mis à jour';
      task.isCompleted = true;
      await repo.update(task);

      final loaded = await repo.getById('a1');
      expect(loaded!.title, 'Mis à jour');
      expect(loaded.isCompleted, isTrue);
    });

    test('update lève TaskNotFoundException si l\'id n\'existe pas', () {
      final task = Task.fromJson({
        'type': 'standard',
        'id': 'absent',
        'title': 'X',
        'priority': 'low',
        'dueDate': null,
        'isCompleted': false,
      });
      expect(() => repo.update(task), throwsA(isA<TaskNotFoundException>()));
    });

    test('supprime une tâche existante', () async {
      final task = Task.fromJson({
        'type': 'standard',
        'id': 'a1',
        'title': 'À supprimer',
        'priority': 'low',
        'dueDate': null,
        'isCompleted': false,
      });
      await repo.save(task);

      await repo.delete('a1');

      expect(await repo.getById('a1'), isNull);
    });

    test('delete lève TaskNotFoundException si l\'id n\'existe pas', () async {
      expect(() => repo.delete('absent'), throwsA(isA<TaskNotFoundException>()));
    });

    test('lève StorageException si le fichier est corrompu', () async {
      File('${tempDir.path}/tasks.json').writeAsStringSync('pas du json {');
      expect(() => repo.getAll(), throwsA(isA<StorageException>()));
    });

    test('persiste le tri et les données après relecture complète', () async {
      await repo.saveAll([
        Task.fromJson({
          'type': 'standard',
          'id': '2',
          'title': 'Deux',
          'priority': 'low',
          'dueDate': null,
          'isCompleted': false,
        }),
        Task.fromJson({
          'type': 'urgent',
          'id': '1',
          'title': 'Un',
          'priority': 'high',
          'urgencyReason': 'Motif',
          'dueDate': null,
          'isCompleted': false,
        }),
      ]);

      final tasks = await repo.getAll();
      expect(tasks.length, 2);
      expect(tasks.map((t) => t.id), ['2', '1']);
    });
  });
}

/// Helper de construction d'une tâche urgente pour les tests.
class UrgentTaskHelper {
  static Task urgent() => Task.fromJson({
        'type': 'urgent',
        'id': 'u1',
        'title': 'Incident',
        'priority': 'high',
        'urgencyReason': 'Panne critique',
        'dueDate': null,
        'isCompleted': false,
      });
}
