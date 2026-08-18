---
name: create-flutter-app
description: Scaffolds a new Flutter application for iOS, Android, and web with a chosen state management approach, linting, and a feature-first directory structure. Guides through platform selection, package setup, and first run on a simulator or emulator. Use when the user wants to create, start, or scaffold a new Flutter or Dart mobile app.
disable-model-invocation: true
argument-hint: "<project-name>"
---

# Create Flutter App

Scaffolds a new Flutter application with sensible defaults and walks the user through platform and package configuration.

## Usage

```
/create-flutter-app my_app
```

Flutter project names must be valid Dart package names: lowercase letters, digits, and underscores only. No hyphens.

## Workflow

### 1. Preflight

- [ ] Confirm Flutter is installed: `flutter --version`. If missing, stop and point the user at `https://docs.flutter.dev/get-started/install`.
- [ ] Run `flutter doctor` and report any failing categories before scaffolding.
- [ ] Validate the project name against `^[a-z][a-z0-9_]*$`. If invalid, suggest a corrected name (hyphens become underscores) and confirm with the user.
- [ ] Confirm the target directory does not already exist.

`flutter doctor` failures are not necessarily blocking — a missing Xcode only
prevents iOS builds, and Android/web still work. Report which targets are
actually available rather than refusing to scaffold.

### 2. Ask the User

Ask these together, with defaults, before running anything:

| Question | Options | Default |
|----------|---------|---------|
| Target platforms | ios, android, web, macos, windows, linux | ios, android |
| State management | Riverpod, Bloc, Provider, none | Riverpod |
| Organization identifier | reverse-domain, e.g. `com.example` | `com.example` |

The organization identifier cannot be changed easily after scaffolding — it
becomes the Android application ID and the iOS bundle identifier prefix. Confirm
it explicitly rather than accepting the default silently.

### 3. Create the Project

```bash
flutter create \
  --org <org-identifier> \
  --platforms=<comma-separated-platforms> \
  --description "<short description>" \
  <project-name>
```

### 4. Add Packages

Install the chosen state management library plus a baseline set:

```bash
cd <project-name>

# State management (pick per the user's answer)
flutter pub add flutter_riverpod        # Riverpod
flutter pub add flutter_bloc bloc       # Bloc
flutter pub add provider                # Provider

# Baseline
flutter pub add go_router               # declarative routing
flutter pub add dio                     # HTTP client
flutter pub add shared_preferences      # local key-value storage

# Dev dependencies
flutter pub add --dev build_runner
flutter pub add --dev flutter_lints
```

Ask before adding anything beyond this baseline. Do not add packages the user
did not request.

### 5. Establish Directory Structure

Create a feature-first layout under `lib/`:

```
lib/
├── main.dart
├── app/
│   ├── app.dart              # root widget, theme, router wiring
│   └── router.dart           # go_router configuration
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/             # API clients, local storage wrappers
└── features/
    └── <feature-name>/
        ├── presentation/     # screens and widgets
        ├── application/      # state notifiers / blocs
        └── domain/           # entities and business rules
```

Create the directories and a placeholder `home` feature so the structure is
demonstrated rather than merely described.

### 6. Configure Linting

Enable a stricter rule set in `analysis_options.yaml`:

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - always_declare_return_types
    - prefer_const_constructors
    - prefer_final_locals
    - avoid_print
    - require_trailing_commas

analyzer:
  errors:
    invalid_annotation_target: ignore
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
```

### 7. Verify

- [ ] `flutter analyze` — must pass with no errors
- [ ] `flutter test` — the default widget test must pass
- [ ] List available devices: `flutter devices`

### 8. Report

Show the user:
- Project path and the platforms enabled
- Packages installed
- The directory structure created
- How to run, per target:

```bash
flutter run                          # first available device
flutter run -d chrome                # web
flutter run -d <simulator-id>        # specific device

# iOS simulator (macOS, requires full Xcode)
open -a Simulator
flutter run -d iPhone

# Android emulator
emulator -list-avds
emulator -avd <avd-name> &
flutter run -d emulator-5554
```

## Notes

- iOS builds require full Xcode, not just Command Line Tools. If `flutter doctor` flags Xcode as incomplete, Android and web targets still work — say so rather than treating it as a hard failure.
- CocoaPods is required for iOS dependency resolution. If `pod --version` fails, install it before the first iOS build.
- `flutter create` on an existing directory adds missing platform folders rather than failing, which is the supported way to add a platform later: `flutter create --platforms=web .`

## Directory Structure

- `resources/` — persistent output and data files generated by this skill
- `scripts/` — reusable scripts for this skill's operations

## Script Management

When performing an operation that can be scripted:
1. Check `scripts/` for an existing script that handles this operation
2. If a script exists, execute it instead of doing the work inline
3. If no script exists and the operation is reusable, create one in `scripts/`, make it executable, then execute it
4. Reference any new scripts in this SKILL.md under "Available Scripts"

## Available Scripts

_No scripts yet. Scripts will be added here as they are created._
