import 'package:task_cli/models/priority.dart';
import 'package:task_cli/models/standard_task.dart';
import 'package:task_cli/models/task.dart';
import 'package:task_cli/models/urgent_task.dart';
import 'package:test/test.dart';

void main() {
  group('Priority.parse', () {
    test('reconnaît les libellés complets', () {
      expect(Priority.parse('low'), Priority.low);
      expect(Priority.parse('medium'), Priority.medium);
      expect(Priority.parse('high'), Priority.high);
    });

    test('reconnaît les abréviations et la casse', () {
      expect(Priority.parse('L'), Priority.low);
      expect(Priority.parse('Medium'), Priority.medium);
      expect(Priority.parse('H'), Priority.high);
    });

    test('retourne low pour une valeur inconnue', () {
      expect(Priority.parse('urgent'), Priority.low);
      expect(Priority.parse(''), Priority.low);
    });
  });

  group('StandardTask', () {
    test('est urgente si la priorité est élevée', () {
      final task = StandardTask(
        id: '1',
        title: 'Livraison',
        priority: Priority.high,
      );
      expect(task.isUrgent, isTrue);
    });

    test('n\'est pas urgente à priorité moyenne ou basse', () {
      final medium = StandardTask(id: '1', title: 'Moyenne');
      final low = StandardTask(id: '2', title: 'Basse', priority: Priority.low);
      expect(medium.isUrgent, isFalse);
      expect(low.isUrgent, isFalse);
    });

    test('sérialise et désérialise un JSON standard', () {
      final task = StandardTask(
        id: '42',
        title: 'Lire un livre',
        priority: Priority.medium,
        dueDate: DateTime(2026, 8, 15),
        isCompleted: true,
      );

      final restored = Task.fromJson(task.toJson());

      expect(restored, isA<StandardTask>());
      expect(restored.id, '42');
      expect(restored.title, 'Lire un livre');
      expect(restored.priority, Priority.medium);
      expect(restored.dueDate, DateTime(2026, 8, 15));
      expect(restored.isCompleted, isTrue);
    });
  });

  group('UrgentTask', () {
    test('force la priorité high et est toujours urgente', () {
      final task = UrgentTask(
        id: '1',
        title: 'Incident',
        urgencyReason: 'Serveur en panne',
      );
      expect(task.priority, Priority.high);
      expect(task.isUrgent, isTrue);
      expect(task.urgencyReason, 'Serveur en panne');
    });

    test('sérialise et désérialise un JSON urgent', () {
      final task = UrgentTask(
        id: '7',
        title: 'Incident',
        urgencyReason: 'Client bloqué',
        dueDate: DateTime(2026, 8, 11),
      );

      final restored = Task.fromJson(task.toJson());

      expect(restored, isA<UrgentTask>());
      expect(restored.id, '7');
      expect((restored as UrgentTask).urgencyReason, 'Client bloqué');
      expect(restored.isUrgent, isTrue);
    });

    test('affichage inclut le motif d\'urgence', () {
      final task = UrgentTask(
        id: '9',
        title: 'Urgence',
        urgencyReason: 'Démo',
      );
      expect(task.toString(), contains('Urgence'));
      expect(task.toString(), contains('Démo'));
    });
  });
}
