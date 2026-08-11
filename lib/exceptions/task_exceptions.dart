abstract class TaskException implements Exception {
  final String message;
  TaskException(this.message);

  @override
  String toString() => 'TaskException: $message';
}

class TaskNotFoundException extends TaskException {
  TaskNotFoundException(String id) : super('Tâche introuvable avec l\'ID : $id');
}

class StorageException extends TaskException {
  StorageException(String detail) : super('Erreur de stockage : $detail');
}

class InvalidTaskDataException extends TaskException {
  InvalidTaskDataException(String detail) : super('Données invalides : $detail');
}