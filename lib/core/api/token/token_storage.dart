import '../../storage/secure_storage.dart';

/// Persists the auth tokens used by the network layer.
///
/// Implement this interface to swap the backing store (e.g. for tests).
abstract class TokenStorage {
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<String?> readAccessToken();

  Future<String?> readRefreshToken();

  Future<void> clear();
}

/// [TokenStorage] backed by [SecureStorage] (Keychain / Keystore).
class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage({SecureStorage? secureStorage})
      : _storage = secureStorage ?? SecureStorage();

  final SecureStorage _storage;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.writeAccessToken(accessToken);
    await _storage.writeRefreshToken(refreshToken);
  }

  @override
  Future<String?> readAccessToken() => _storage.readAccessToken();

  @override
  Future<String?> readRefreshToken() => _storage.readRefreshToken();

  @override
  Future<void> clear() => _storage.deleteTokens();
}
