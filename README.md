# Flutter Enterprise Starter

A scalable, feature-first Flutter mobile app built on **clean architecture** and
industry best practices.

## Architecture

- **Feature-first** — each feature in `lib/features/` is self-contained with its
  own `data` / `domain` / `presentation` layers (clean architecture).
- **Layered core** — cross-cutting concerns live in `lib/core/`.
- **Shared UI** — reusable components in `lib/shared/`.
- **Centralized config** — environment, routing, theme, and l10n in `lib/config/`.

## Project Structure

```
lib/
├── core/                  # App-wide kernel
│   ├── api/               # Dio client, interceptors, API helpers
│   ├── storage/           # Local persistence (shared_preferences, etc.)
│   ├── theme/             # Theme data / design tokens
│   ├── routing/           # GoRouter setup
│   ├── di/                # Dependency injection (Riverpod providers)
│   ├── utils/             # Helpers, formatters
│   ├── constants/         # App-wide constants
│   ├── errors/            # Failures, exceptions, result types
│   └── extensions/        # Dart/Kotlin-style extension methods
├── features/              # Feature modules
│   ├── auth/              # Authentication feature
│   ├── home/              # Home feature (clean architecture)
│   │   ├── data/          # datasources, models, repositories (impl)
│   │   ├── domain/        # entities, repository interfaces, use cases
│   │   └── presentation/  # state (bloc), pages, widgets
│   └── settings/          # Settings feature
├── shared/                # Reusable code across features
│   ├── widgets/           # Reusable widgets
│   ├── models/            # Cross-feature shared models/DTOs
│   ├── components/        # Composite UI components
│   └── layouts/           # Screen/layout scaffolds
├── config/                # Environment, routing constants, l10n
│   ├── env/
│   └── l10n/              # ARB translation files
└── main.dart              # App entry point (DI + routing bootstrap)
assets/
├── images/
├── icons/
└── fonts/
test/
├── unit/                  # Pure Dart unit tests
├── widget/                # Widget/UI tests
└── integration/          # End-to-end tests
```

## Tech Stack

| Concern        | Package                |
| -------------- | ---------------------- |
| State + DI     | `flutter_riverpod`     |
| Routing        | `go_router`            |
| Networking     | `dio`                  |
| Local storage  | `shared_preferences` + `flutter_secure_storage` |
| Connectivity   | `connectivity_plus`    |
| Logging        | `logger`               |
| Immutability   | `freezed`              |
| Serialization  | `json_serializable` + `intl` |
| Codegen        | `build_runner`         |
| i18n           | `intl` / l10n          |

## Getting Started

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

Analyze and test:

```bash
flutter analyze
flutter test
```

## Conventions

- Dependencies are injected via `core/di` — never instantiate services directly
  inside widgets.
- Features depend only on `core` and `shared`; `core` never imports `features`.
- Domain layer is framework-agnostic (no Flutter / Dio imports).
- All user-facing strings go in `config/l10n` (no hardcoded text).
- Empty directories are kept in git via `.gitkeep`.

## Roadmap

- [ ] Implement `core/api` Dio client with auth & logging interceptors
- [ ] Implement `core/storage` secure/local persistence
- [ ] Wire `core/routing` with guarded routes
- [ ] Add dev / staging / prod environment config
- [ ] Scaffold additional feature modules
