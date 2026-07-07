import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../token/token_manager.dart';

/// Handles 401 responses by refreshing the access token and replaying the
/// original request exactly once.
///
/// Uses a dedicated, interceptor-free [Dio] instance for the refresh call to
/// avoid recursive 401 handling. A per-request flag prevents infinite loops,
/// and the shared [TokenManager.refresh] dedupes concurrent refreshes.
class RefreshTokenInterceptor extends QueuedInterceptor {
  RefreshTokenInterceptor({
    required this.tokenManager,
    required this.refreshDio,
    this.logger,
  });

  final TokenManager tokenManager;
  final Dio refreshDio;
  final Logger? logger;

  static const String _refreshedKey = 'x_token_refreshed';

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final statusCode = err.response?.statusCode;
    final alreadyRefreshed = options.extra[_refreshedKey] == true;

    if (statusCode != 401 || alreadyRefreshed) {
      return handler.next(err);
    }

    try {
      final newToken = await tokenManager.refresh();

      if (newToken == null || newToken.isEmpty) {
        await tokenManager.clear();
        logger?.w('Token refresh failed — clearing session');
        return handler.next(err);
      }

      // Replay the original request with the fresh access token.
      options.extra[_refreshedKey] = true;
      options.headers[HttpHeaders.authorizationHeader] = 'Bearer $newToken';

      final response = await refreshDio.fetch(options);
      return handler.resolve(response);
    } catch (e) {
      await tokenManager.clear();
      logger?.e('Token refresh error — clearing session', error: e);
      return handler.next(err);
    }
  }
}
