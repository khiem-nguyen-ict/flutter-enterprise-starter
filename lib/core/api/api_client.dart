import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../config/env/env.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logger_interceptor.dart';
import 'interceptors/refresh_token_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import '../storage/storage_providers.dart';
import 'token/token_manager.dart';
import 'token/token_storage.dart';

/// Path of the refresh-token endpoint (relative to [Env.apiBaseUrl]).
const String refreshTokenPath = '/auth/refresh';

/// Pretty logger shared by the network layer.
final networkLoggerProvider = Provider<Logger>((ref) {
  return Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
    level: kReleaseMode ? Level.warning : Level.trace,
  );
});

/// Secure token storage (delegates to [SecureStorage]).
final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return SecureTokenStorage(secureStorage: ref.watch(secureStorageProvider));
});

/// Plain [Dio] used exclusively for the token-refresh call. It deliberately
/// has no interceptors to avoid recursive 401 handling / logging noise.
final refreshDioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: Env.apiBaseUrl,
    connectTimeout: const Duration(milliseconds: Env.connectTimeoutMs),
    receiveTimeout: const Duration(milliseconds: Env.receiveTimeoutMs),
    sendTimeout: const Duration(milliseconds: Env.sendTimeoutMs),
    headers: {'Accept': 'application/json'},
  ));
});

/// Coordinates access/refresh tokens.
final tokenManagerProvider = Provider<TokenManager>((ref) {
  return TokenManagerImpl(
    storage: ref.watch(tokenStorageProvider),
    refreshDio: ref.watch(refreshDioProvider),
    refreshPath: refreshTokenPath,
  );
});

/// The configured application [Dio] client.
///
/// Pipeline (outer → inner): Auth → Logger → Retry → RefreshToken.
final dioProvider = Provider<Dio>((ref) {
  final logger = ref.watch(networkLoggerProvider);
  final tokenManager = ref.watch(tokenManagerProvider);
  final refreshDio = ref.watch(refreshDioProvider);

  final dio = Dio(BaseOptions(
    baseUrl: Env.apiBaseUrl,
    connectTimeout: const Duration(milliseconds: Env.connectTimeoutMs),
    receiveTimeout: const Duration(milliseconds: Env.receiveTimeoutMs),
    sendTimeout: const Duration(milliseconds: Env.sendTimeoutMs),
    headers: {'Accept': 'application/json'},
  ));

  dio.interceptors.addAll(<Interceptor>[
    AuthInterceptor(tokenManager: tokenManager),
    LoggerInterceptor(logger),
    RetryInterceptor(dio: dio, logger: logger),
    RefreshTokenInterceptor(
      tokenManager: tokenManager,
      refreshDio: refreshDio,
      logger: logger,
    ),
  ]);

  return dio;
});
