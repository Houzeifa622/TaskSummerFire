import 'dart:io';

import 'package:task_cli/exceptions/task_exceptions.dart';
import 'package:task_cli/models/priority.dart';
import 'package:task_cli/repositories/json_task_repository.dart';
import 'package:task_cli/services/task_manager.dart';

/// Point d'entrée de l'application CLI. Démarre la boucle interactive
/// de gestion des tâches.
Future<void> runCli() async {
  final repo = JsonTaskRepository('tasks.json');
  final manager = TaskManager(repo);

  print('========================================');
  print('     GESTIONNAIRE DE TÂCHES (CLI)      ');
  print('========================================');

  while (true) {
    print('\nMenu:');
    print('1. Ajouter une tâche');
    print('2. Lister les tâches (par Priorité)');
    print('3. Lister les tâches (par Date d\'échéance)');
    print('4. Marquer une tâche comme terminée');
    print('5. Supprimer une tâche');
    print('6. Quitter');
    stdout.write('\nChoix > ');

    final choice = stdin.readLineSync()?.trim();

    try {
      switch (choice) {
        case '1':
          await _addTaskFlow(manager);
          break;
        case '2':
          await _listTasksFlow(manager, SortStrategy.priority);
          break;
        case '3':
          await _listTasksFlow(manager, SortStrategy.dueDate);
          break;
        case '4':
          await _completeTaskFlow(manager);
          break;
        case '5':
          await _deleteTaskFlow(manager);
          break;
        case '6':
          print('\nAu revoir !');
          exit(0);
        default:
          print('Option invalide.');
      }
    } on TaskException catch (e) {
      print('❌ Erreur : ${e.message}');
    } catch (e) {
      print('❌ Erreur inattendue : $e');
    }
  }
}

Future<void> _addTaskFlow(TaskManager manager) async {
  stdout.write('Titre de la tâche : ');
  final title = stdin.readLineSync() ?? '';

  stdout.write('Priorité (low/medium/high) [medium] : ');
  final pInput = stdin.readLineSync() ?? 'medium';
  final priority = Priority.parse(pInput);

  stdout.write('Est-ce une tâche urgente avec motif ? (o/N) : ');
  final isUrgent = (stdin.readLineSync() ?? '').toLowerCase() == 'o';
  String? urgencyReason;

  if (isUrgent) {
    stdout.write('Motif d\'urgence : ');
    urgencyReason = stdin.readLineSync();
  }

  stdout.write('Date d\'échéance (AAAA-MM-JJ) [optionnel] : ');
  final dateStr = stdin.readLineSync()?.trim();
  DateTime? dueDate;
  if (dateStr != null && dateStr.isNotEmpty) {
    dueDate = DateTime.tryParse(dateStr);
  }

  final task = await manager.addTask(
    title: title,
    priority: priority,
    dueDate: dueDate,
    urgencyReason: urgencyReason,
  );

  print('Tâche créée avec succès [ID: ${task.id}]');
}

Future<void> _listTasksFlow(TaskManager manager, SortStrategy sort) async {
  final tasks = await manager.listTasks(sort: sort);
  if (tasks.isEmpty) {
    print('\nAucune tâche enregistrée.');
    return;
  }

  print('\n--- Liste des Tâches (${sort.name}) ---');
  for (var task in tasks) {
    print(task);
  }
}

Future<void> _completeTaskFlow(TaskManager manager) async {
  stdout.write('ID de la tâche terminée : ');
  final id = stdin.readLineSync()?.trim() ?? '';
  await manager.completeTask(id);
  print('Tâche $id marquée comme terminée.');
}

Future<void> _deleteTaskFlow(TaskManager manager) async {
  stdout.write('ID de la tâche à supprimer : ');
  final id = stdin.readLineSync()?.trim() ?? '';
  await manager.removeTask(id);
  print('Tâche $id supprimée.');
}