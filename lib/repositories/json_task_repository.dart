import 'dart:convert';
import 'dart:io';

import '../exceptions/task_exceptions.dart';
import '../models/standard_task.dart';
import '../models/task.dart';
import '../models/urgent_task.dart';
import 'repository_interface.dart';

class JsonTaskRepository implements Repository<Task> {
  final String filePath;

  JsonTaskRepository([this.filePath = 'tasks.json']);

  Future<File> get _file async {
    final file = File(filePath);
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString('[]');
    }
    return file;
  }

  @override
  Future<List<Task>> getAll() async {
    try {
      final file = await _file;
      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(content) as List<dynamic>;
      return jsonList.map((item) {
        final map = item as Map<String, dynamic>;
        if (map['type'] == 'urgent') {
          return UrgentTask.fromJson(map);
        }
        return StandardTask.fromJson(map);
      }).toList();
    } catch (e) {
      throw StorageException('Échec de la lecture du fichier : $e');
    }
  }

  @override
  Future<Task?> getById(String id) async {
    final tasks = await getAll();
    try {
      return tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(Task item) async {
    final tasks = await getAll();
    tasks.add(item);
    await saveAll(tasks);
  }

  @override
  Future<void> update(Task item) async {
    final tasks = await getAll();
    final index = tasks.indexWhere((t) => t.id == item.id);
    if (index == -1) throw TaskNotFoundException(item.id);

    tasks[index] = item;
    await saveAll(tasks);
  }

  @override
  Future<void> delete(String id) async {
    final tasks = await getAll();
    final initialLength = tasks.length;
    tasks.removeWhere((t) => t.id == id);

    if (tasks.length == initialLength) {
      throw TaskNotFoundException(id);
    }
    await saveAll(tasks);
  }

  @override
  Future<void> saveAll(List<Task> items) async {
    try {
      final file = await _file;
      final jsonList = items.map((t) => t.toJson()).toList();
      await file.writeAsString(const JsonEncoder.withIndent('  ').convert(jsonList));
    } catch (e) {
      throw StorageException('Échec de la sauvegarde : $e');
    }
  }
}