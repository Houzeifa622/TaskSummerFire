# 📝 Task CLI — Gestionnaire de Tâches en Dart

Application CLI complète de gestion de tâches développée en Dart pur.

## 📋 Fonctionnalités
- Ajouter une tâche (titre, priorité `low`/`medium`/`high`, date limite optionnelle).
- Lister toutes les tâches avec tri par **priorité** ou **date d'échéance**.
- Marquer une tâche comme terminée.
- Supprimer une tâche.
- Persistance locale automatique dans un fichier `tasks.json`.

## 🛠️ Architecture & Concepts Métiers
- **Classe abstraite & Héritage :** `Task` (abstraite) implémentée par `StandardTask` et `UrgentTask`.
- **Génériques & Interfaces :** Contrat `Repository<T>` implémenté par `JsonTaskRepository`.
- **Exceptions sur-mesure :** `TaskNotFoundException`, `InvalidTaskDataException`, `StorageException`.

## 🚀 Exécution
1. Récupérer les dépendances :
   ```bash
   dart pub get