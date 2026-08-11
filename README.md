# 📝 Task CLI — Gestionnaire de Tâches en Dart pur

Application CLI (ligne de commande) de gestion de tâches développée en **Dart pur**,
sans dépendance Flutter. Les données sont persistées dans un fichier JSON local.

## ✨ Fonctionnalités

- **Ajout de tâche** : titre, priorité (`low` / `medium` / `high`), date d'échéance
  optionnelle (`AAAA-MM-JJ`) et motif d'urgence pour les tâches urgentes.
- **Consultation & tri** : liste triée par **priorité** ou par **date d'échéance**
  (les tâches sans date apparaissent en fin de liste).
- **Gestion du statut** : marquer une tâche comme terminée (`[✓]`).
- **Suppression** : retrait définitif d'une tâche via son identifiant unique.
- **Persistance** : sauvegarde automatique dans le fichier local `tasks.json`
  (créé automatiquement au premier lancement).

## 🚀 Installation

Prérequis : [SDK Dart](https://dart.dev/get-dart) (>= 3.12).

```bash
git clone git@github.com:Houzeifa622/TaskSummerFire.git
cd TaskSummerFire/task_cli
dart pub get
```

## ▶️ Exécution

```bash
dart run
```

Un menu interactif s'affiche :

```
1. Ajouter une tâche
2. Lister les tâches (par Priorité)
3. Lister les tâches (par Date d'échéance)
4. Marquer une tâche comme terminée
5. Supprimer une tâche
6. Quitter
```

## 🧪 Tests

```bash
dart test
```

La suite couvre la logique métier (`TaskManager`), la persistance
(`JsonTaskRepository`), les modèles et les exceptions :

- création de tâches standard / urgentes et validation du titre ;
- tris par priorité et par date d'échéance ;
- complétion et suppression (y compris les erreurs `TaskNotFoundException`) ;
- sérialisation / désérialisation JSON et persistance inter-exécutions ;
- gestion des fichiers corrompus (`StorageException`) ;
- parsing des priorités et comportement des modèles.

## 🏗️ Architecture

Le projet suit une architecture en couches :

```text
task_cli/
├── bin/
│   └── task_cli.dart              # Point d'entrée exécutable
├── lib/
│   ├── main.dart                  # Logique de l'interface console (runCli)
│   ├── exceptions/
│   │   └── task_exceptions.dart   # Exceptions sur-mesure
│   ├── models/
│   │   ├── priority.dart          # Enum Priority avec parsing
│   │   ├── task.dart              # Classe abstraite + factory Task.fromJson
│   │   ├── standard_task.dart     # Tâche classique (urgente si high)
│   │   └── urgent_task.dart       # Tâche urgente avec motif
│   ├── repositories/
│   │   ├── repository_interface.dart  # Interface générique Repository<T>
│   │   └── json_task_repository.dart  # Implémentation JSON (fichier local)
│   └── services/
│       └── task_manager.dart      # Logique métier : ajout, tris, statut
├── test/                          # Tests unitaires Dart
├── tasks.json                     # Stockage persistant (généré)
├── analysis_options.yaml          # Configuration lints
└── pubspec.yaml                   # Package Dart pur
```

## 🔄 Intégration continue

Le workflow `.github/workflows/dart_ci.yml` exécute `dart pub get`, `dart analyze`
et `dart test` sur chaque push / pull request.
