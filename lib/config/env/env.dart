/// Application environment configuration.
///
/// Values are compile-time constants resolvable via `--dart-define`, with
/// sensible defaults for local development.
class Env {
  const Env._();

  /// Base URL of the backend API.
  ///
  /// Override at build time, e.g.:
  /// `flutter run --dart-define=API_BASE_URL=https://api.example.com`
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  /// Connect timeout in milliseconds.
  static const int connectTimeoutMs = int.fromEnvironment(
    'CONNECT_TIMEOUT_MS',
    defaultValue: 15000,
  );

  /// Receive timeout in milliseconds.
  static const int receiveTimeoutMs = int.fromEnvironment(
    'RECEIVE_TIMEOUT_MS',
    defaultValue: 15000,
  );

  /// Send timeout in milliseconds.
  static const int sendTimeoutMs = int.fromEnvironment(
    'SEND_TIMEOUT_MS',
    defaultValue: 15000,
  );
}
