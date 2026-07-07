# Flutter Enterprise Starter

A scalable, feature-first Flutter mobile app built on **clean architecture** and
industry best practices.

## Networking

The network layer lives in `lib/core/api/` and is built on **Dio** with a
layered interceptor pipeline. It is provided via Riverpod — never instantiate
`Dio` or `ApiClient` by hand inside features.

```
Dio
 └─ AuthInterceptor            attaches `Bearer <accessToken>` to requests
 └─ LoggerInterceptor          logs requests/responses/errors (logger)
 └─ RetryInterceptor           retries transient failures w/ backoff
 └─ RefreshTokenInterceptor    on 401, refreshes token & replays request
```

Files:

| File | Responsibility |
| ---- | -------------- |
| `api_client.dart` | `Dio` factory + Riverpod providers (`dioProvider`, `tokenManagerProvider`, …) |
| `api_client_helper.dart` | `ApiClient` — typed `get/post/put/patch/delete` wrapping `Dio`, throws `ApiFailure` |
| `interceptors/auth_interceptor.dart` | Adds the access token header |
| `interceptors/logger_interceptor.dart` | Pretty request/response/error logging |
| `interceptors/retry_interceptor.dart` | Exponential-backoff retry for network errors & 5xx |
| `interceptors/refresh_token_interceptor.dart` | Token refresh on 401 (single replay) |
| `token/token_storage.dart` | `TokenStorage` (Keychain/Keystore via `flutter_secure_storage`) |
| `token/token_manager.dart` | `TokenManager` — access/refresh coordination, deduped refresh |
| `failures.dart` | `ApiFailure` hierarchy + `DioException` mapper |
| `config/env/env.dart` | `Env` — base URL, timeouts (compile-time via `--dart-define`) |

### Usage

```dart
final api = ref.read(apiClientProvider);
try {
  final user = await api.get<Map<String, dynamic>>('/me');
} on UnauthorizedFailure {
  // token refresh failed; route to login
} on NetworkFailure {
  // offline
} on ApiFailure catch (e) {
  // surface e.message
}
```

### How it works

- **Auth** — `AuthInterceptor` reads the current access token from
  `TokenManager` and sets `Authorization: Bearer …`. Endpoints that must stay
  anonymous can set their own header to opt out.
- **Retry** — only transient failures (timeouts, connection errors, 5xx) are
  retried, up to 3 times with increasing delay. Auth errors are intentionally
  skipped so they reach the refresh step instead.
- **Refresh** — on a `401`, `RefreshTokenInterceptor` calls `TokenManager.refresh()`
  (which exchanges the refresh token via a dedicated, interceptor-free Dio
  instance) and replays the original request once with the new token.
  Concurrent 401s share a single in-flight refresh, and a per-request flag
  prevents infinite loops. When refresh is impossible the session is cleared.
- **Errors** — every `DioException` is mapped to a domain `ApiFailure`
  (`NetworkFailure`, `TimeoutFailure`, `UnauthorizedFailure`, `ClientFailure`,
  `ServerFailure`, `UnknownFailure`) so the presentation layer never sees
  networking internals.

### Configuration

```bash
flutter run --dart-define=API_BASE_URL=https://api.example.com
```

## Local Storage

The persistence layer lives in `lib/core/storage/` and is split by security
sensitivity. It is provided via Riverpod — never instantiate the stores
directly inside features.

```
SecureStorage        → access_token, refresh_token   (Keychain / Keystore)
AppSettingsStorage   → theme_mode, locale            (SharedPreferences)
```

- **Secure storage** — `SecureStorage` wraps `flutter_secure_storage` and holds
  the auth tokens. `core/api/token/token_storage.dart`'s `SecureTokenStorage`
  delegates to it, so there is a single source of truth for secure values.
- **App settings** — `AppSettingsStorage` wraps `shared_preferences` and holds
  non-sensitive preferences. `SharedPreferences` is initialized once in
  `main.dart` and injected through `sharedPreferencesProvider`.

Providers:

| Provider | Type |
| -------- | ---- |
| `secureStorageProvider` | `SecureStorage` |
| `sharedPreferencesProvider` | `SharedPreferences` |
| `appSettingsStorageProvider` | `AppSettingsStorage` |

## Internationalization (i18n)

The app uses `flutter gen-l10n` with ARB files. Locale is persisted via
`AppSettingsStorage` and can be changed at runtime from Settings.

Supported locales: **English (en)**, **Finnish (fi)**, **Vietnamese (vi)**.

Files:

| File | Responsibility |
| ---- | -------------- |
| `lib/config/l10n/intl_en.arb` | English strings (template) |
| `lib/config/l10n/intl_fi.arb` | Finnish strings |
| `lib/config/l10n/intl_vi.arb` | Vietnamese strings |
| `lib/config/l10n/app_localizations.dart` | Generated `AppLocalizations` class + delegates |
| `lib/config/l10n/app_localizations_en.dart` | Generated English localization |
| `lib/config/l10n/app_localizations_fi.dart` | Generated Finnish localization |
| `lib/config/l10n/app_localizations_vi.dart` | Generated Vietnamese localization |
| `lib/config/locale/locale_notifier.dart` | `LocaleNotifier` — persists/loads selected locale |

### Usage

```dart
final l10n = AppLocalizations.of(context);
Text(l10n.appTitle);
```

### Changing locale

Users can switch language from **Settings** using EN / FI / VI chips. The
choice is saved to `SharedPreferences` and restored on app start.

### Adding a new language

1. Add a new ARB file: `lib/config/l10n/intl_<lang>.arb`
2. Mirror all keys from `intl_en.arb`
3. Run `flutter gen-l10n` to regenerate localized classes
4. Update `supportedLocales` and `_AppLocalizationsDelegate.isSupported` in
   `app_localizations.dart`

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
│   ├── auth/               # Authentication feature
│   │   └── presentation/   # splash + login pages
│   ├── home/              # Home feature (clean architecture)
│   │   ├── data/          # datasources, models, repositories (impl)
│   │   ├── domain/        # entities, repository interfaces, use cases
│   │   └── presentation/  # state (bloc), pages, widgets
│   ├── profile/           # Profile feature (mock user, demo)
│   │   ├── domain/        # entity (User)
│   │   └── presentation/  # provider (mock data) + pages
│   └── settings/          # Settings feature
├── shared/                # Reusable code across features
│   ├── widgets/           # Reusable widgets
│   ├── models/            # Cross-feature shared models/DTOs
│   ├── components/        # Composite UI components
│   └── layouts/           # Screen/layout scaffolds
├── config/                # Environment, routing constants, l10n, locale state, theme state
│   ├── env/
│   ├── l10n/              # ARB translation files + generated localizations
│   ├── locale/            # Locale notifier (Riverpod state for app language)
│   └── theme/             # Theme mode notifier (Riverpod state for Light / Dark / System)
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
| i18n           | `flutter_localizations` / `intl` / l10n |

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

## Design System / Theme

The theme lives in `lib/core/theme/` and is organized as a token hierarchy:

```
Theme
├── Color       → app_colors.dart      (Material 3 ColorScheme via seed)
├── Typography   → app_typography.dart  (Material 3 type scale, themed)
├── Spacing      → app_spacing.dart     (4pt grid: none→huge + insets)
├── Radius       → app_radius.dart      (none→full corner tokens)
└── Elevation    → app_elevation.dart   (none→highest + shadow helper)
```

Each non-color token is a `ThemeExtension`, so it is attached to `ThemeData`
and accessed uniformly through `BuildContext` (see `theme_extensions.dart`):

```dart
import 'core/theme/theme.dart';

Container(
  padding: context.spacing.cardPadding,
  decoration: BoxDecoration(
    borderRadius: context.radius.mdRadius,
    boxShadow: context.elevation.shadow(context.elevation.medium),
  ),
  child: Text('Hello', style: context.typography.titleLarge),
);
```

- **Color** — `AppColors.lightColorScheme` / `darkColorScheme` are generated
  from a single brand `seed` via `ColorScheme.fromSeed` (Material 3).
- **Typography** — full Material 3 scale; colors track `onSurface` so it
  adapts to light/dark automatically. Also exposed as `ThemeData.textTheme`.
- **Theme assembly** — `AppTheme.light()` / `AppTheme.dark()` in `app_theme.dart`

### Theme Modes (Light / Dark / System)

The app supports three theme modes, persisted in `SharedPreferences`:

- **Light** — always uses the light color scheme.
- **Dark** — always uses the dark color scheme.
- **System** — follows the OS `platformBrightness` (default).

Files:

| File | Responsibility |
| ---- | -------------- |
| `config/theme/theme_notifier.dart` | `ThemeModeNotifier` — Riverpod state for theme mode |
| `core/theme/app_theme.dart` | `AppTheme.light()` / `AppTheme.dark()` assembly |
| `core/storage/app_settings_storage.dart` | Persists theme mode as string (`light`, `dark`, `system`) |
| `features/settings/presentation/pages/settings_page.dart` | UI toggle (Light / Dark / System chips) |

### Usage

```dart
final themeMode = ref.watch(themeModeProvider); // ThemeMode.light | dark | system
ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
```

In `main.dart`:

```dart
themeMode: ref.watch(themeModeProvider),
```

## Routing

Navigation is handled by `go_router` with Riverpod-powered route guards.

- **Route config**: `lib/core/routing/app_router.dart`
- **Flow**: `/splash` → `/login` → `/home` → `/profile` → `/settings`
- **State guard**: `AuthStatus` enum in `lib/features/auth/data/providers/auth_provider.dart`
  - `unknown` → `/splash`
  - `unauthenticated` → `/login`
  - `authenticated` → `/home`, `/profile`, or `/settings`

Central route paths in `app_router.dart`:
- `splashRoutePath`
- `loginRoutePath`
- `homeRoutePath`
- `profileRoutePath`
- `settingsRoutePath`


## Demo (Mock Data)

The app ships with a fully clickable demo flow backed by **mock data** so you
can explore the UI without a backend. `AuthNotifier.checkAuth()` starts
`unauthenticated`, so the app opens at **Login**.

```
Login  ──▶  Home  ──▶  Profile  ──▶  Settings
  │                     │                  │
  └─────────────────────┴──────────────────┘  (Log out → Login)
```

- **Login** (`lib/features/auth/presentation/pages/login_page.dart`) — mock
  email/password form, pre-filled with `ada.lovelace@example.com` / `demo1234`.
  `login()` sets `authenticated` and navigates to Home.
- **Home** (`lib/features/home/presentation/pages/home_page.dart`) — dashboard
  with mock KPI cards, a profile summary card, and a recent-activity feed.
  "View Profile" opens the Profile page.
- **Profile** (`lib/features/profile/presentation/pages/profile_page.dart`) —
  renders the mock `User` (name, email, role, bio, location, join date, follower
  stats, interest chips). Links to **Settings** / **Edit Profile** / **Log out**.
- **Settings** (`lib/features/settings/presentation/pages/settings_page.dart`) —
  theme + locale switches and a **Log out** button (returns to Login).

### Swapping mock data for a real backend

- **Auth** — replace the token check in `checkAuth()` with a real persisted-token
  read, and have `login()` call `api.post('/auth/login', …)` instead of faking
  success.
- **Profile** — replace `mockUserProvider`
  (`lib/features/profile/presentation/provider/mock_user_provider.dart`) with a
  provider backed by a real repository / data source.
- **Home** — feed the dashboard cards and activity feed from real API responses.

## Roadmap

- [x] Add demo flow with mock data (Login → Home → Profile → Settings)
- [x] Wire `core/routing` with guarded routes
- [x] Implement `core/api` Dio client with auth, logging, retry & refresh-token interceptors
- [x] Implement `core/storage` secure/local persistence
- [ ] Add dev / staging / prod environment config
- [ ] Scaffold additional feature modules
