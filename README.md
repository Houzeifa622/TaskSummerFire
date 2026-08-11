# 📝 Task CLI — Gestionnaire de Tâches en Dart

Application CLI complète de gestion de tâches développée en Dart pur.

## 📋 Fonctionnalités
- **Ajout de tâche :** Titre, priorité (`low`/`medium`/`high`), date limite optionnelle et motif d'urgence pour les tâches prioritaires.
- **Consultation & Tri :** Affichage dynamique avec tri par **priorité** ou **date d'échéance**.
- **Gestion du statut :** Marquer une tâche comme terminée (`[✓]`).
- **Suppression :** Retrait définitif d'une tâche via son identifiant unique.
- **Persistance des données :** Sauvegarde automatique dans un fichier local `tasks.json`.

## 🛠️ Architecture & Exigences Techniques
- **Classes Abstraites & Héritage :** Classe abstraite `Task` dérivée en `StandardTask` et `UrgentTask`.
- **Génériques & Interface :** Contrat générique `Repository<T>` implémenté par `JsonTaskRepository`.
- **Exceptions sur-mesure :** Gestion fine des erreurs via `TaskNotFoundException`, `InvalidTaskDataException` et `StorageException`.
- **Tests Unitaires :** Suite de tests automatisés couvrant les cas nominaux et d'erreurs.

## 📁 Structure du Projet
```text
task_cli/
├── bin/
│   └── main.dart                  # Point d'entrée de l'application CLI
├── lib/
│   ├── exceptions/
│   │   └── task_exceptions.dart   # Exceptions personnalisées
│   ├── models/
│   │   ├── priority.dart          # Enum de priorité
│   │   ├── task.dart              # Classe abstraite de base
│   │   ├── standard_task.dart     # Tâche classique
│   │   └── urgent_task.dart       # Tâche urgente avec motif
│   ├── repositories/
│   │   ├── repository_interface.dart # Interface générique Repository<T>
│   │   └── json_task_repository.dart # Implémentation JSON
│   └── services/
│       └── task_manager.dart      # Logique métier et tris
├── test/
│   └── task_manager_test.dart     # Tests unitaires
├── tasks.json                     # Stockage persistant
├── pubspec.yaml                   # Fichier de configuration du projet
└── README.md