import 'package:dio/dio.dart';

import 'token_storage.dart';

/// Coordinates access/refresh tokens and the refresh flow.
///
/// The network interceptors depend only on this abstraction, never on a
/// concrete store or HTTP call, which keeps them testable.
abstract class TokenManager {
  /// Current access token, or `null` if the user is signed out.
  Future<String?> get accessToken;

  /// Current refresh token, or `null` if the user is signed out.
  Future<String?> get refreshToken;

  /// Persists a freshly issued token pair.
  Future<void> save({
    required String accessToken,
    required String refreshToken,
  });

  /// Exchanges the refresh token for a new access token.
  ///
  /// Returns the new access token, or `null` when no valid session exists.
  Future<String?> refresh();

  /// Drops all tokens (e.g. on logout or an unrecoverable 401).
  Future<void> clear();
}

/// Default [TokenManager] implementation.
///
/// [refresh] is de-duplicated: concurrent 401s share a single in-flight
/// refresh so the refresh endpoint is hit at most once per session.
class TokenManagerImpl implements TokenManager {
  TokenManagerImpl({
    required TokenStorage storage,
    required Dio refreshDio,
    required String refreshPath,
    String accessTokenField = 'access_token',
    String refreshTokenField = 'refresh_token',
  })  : _storage = storage,
        _refreshDio = refreshDio,
        _refreshPath = refreshPath,
        _accessTokenField = accessTokenField,
        _refreshTokenField = refreshTokenField;

  final TokenStorage _storage;
  final Dio _refreshDio;
  final String _refreshPath;
  final String _accessTokenField;
  final String _refreshTokenField;

  Future<String?>? _refreshFuture;

  @override
  Future<String?> get accessToken => _storage.readAccessToken();

  @override
  Future<String?> get refreshToken => _storage.readRefreshToken();

  @override
  Future<void> save({
    required String accessToken,
    required String refreshToken,
  }) =>
      _storage.saveTokens(accessToken: accessToken, refreshToken: refreshToken);

  @override
  Future<String?> refresh() {
    // Share a single in-flight refresh across all concurrent callers.
    return _refreshFuture ??= _doRefresh().whenComplete(() {
      _refreshFuture = null;
    });
  }

  Future<String?> _doRefresh() async {
    final refreshToken = await _storage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return null;

    try {
      final response = await _refreshDio.post(
        _refreshPath,
        data: {_refreshTokenField: refreshToken},
      );

      if (response.statusCode != 200 || response.data is! Map<String, dynamic>) {
        return null;
      }

      final data = response.data as Map<String, dynamic>;
      final newAccessToken = data[_accessTokenField] as String?;
      final newRefreshToken = data[_refreshTokenField] as String?;

      if (newAccessToken == null || newAccessToken.isEmpty) return null;

      await _storage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken ?? refreshToken,
      );
      return newAccessToken;
    } on DioException {
      return null;
    }
  }

  @override
  Future<void> clear() => _storage.clear();
}
